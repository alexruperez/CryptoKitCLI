import ArgumentParser
import CryptoKit
import Foundation
import PathKit
import Rainbow

public struct CryptoKitCLI: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "cryptokit",
        abstract: "Perform cryptographic operations securely and efficiently.",
        version: "CryptoKitCLI v0.1.0",
        subcommands: [UUIDCommand.self, HashCommand.self, HMACCommand.self]
    )

    public init() {}
}

public extension CryptoKitCLI {
    struct UUIDCommand: ParsableCommand {
        public static var configuration = CommandConfiguration(
            commandName: "uuid",
            abstract: "Create or validate a universally unique value."
        )

        @Option(name: .shortAndLong,
                help: "Validate UUID string or file path.")
        public var check: String?

        public var checkString: String? {
            guard let checkPath = check else {
                return check
            }
            do {
                return try string(checkPath)
            } catch {
                return check
            }
        }

        public init() {}

        public func run() throws {
            guard let check = checkString else {
                print(UUID().uuidString.bold)
                throw ExitCode.success
            }
            if UUID(uuidString: check) != nil {
                print("Valid".underline.green)
                throw ExitCode.success
            } else {
                print("Invalid".underline.red)
                throw ExitCode.failure
            }
        }
    }
}

public enum Digest: String, ExpressibleByArgument {
    public static let algorithm = "SHA-2"

    case sha512
    case sha384
    case sha256

    public func hash(_ data: Data) -> String {
        switch self {
        case .sha512:
            return SHA512.hash(data: data)
        case .sha384:
            return SHA384.hash(data: data)
        case .sha256:
            return SHA256.hash(data: data)
        }
    }

    public func authenticationCode(data: Data, key: SymmetricKey) -> String {
        switch self {
        case .sha512:
            return SHA512.authenticationCode(data: data, key: key)
        case .sha384:
            return SHA384.authenticationCode(data: data, key: key)
        case .sha256:
            return SHA256.authenticationCode(data: data, key: key)
        }
    }

    public func isValid(code: Data, data: Data, key: SymmetricKey) -> Bool {
        switch self {
        case .sha512:
            return SHA512.isValid(code: code, data: data, key: key)
        case .sha384:
            return SHA384.isValid(code: code, data: data, key: key)
        case .sha256:
            return SHA256.isValid(code: code, data: data, key: key)
        }
    }
}

public extension HashFunction {
    static func hash(data: Data) -> String {
        hash(data: data).string
    }

    static func authenticationCode(data: Data, key: SymmetricKey) -> String {
        HMAC<Self>.authenticationCode(for: data, using: key).string
    }

    static func isValid(code: Data, data: Data, key: SymmetricKey) -> Bool {
        HMAC<Self>.isValidAuthenticationCode(code, authenticating: data, using: key)
    }
}

public extension CryptoKitCLI {
    struct HashCommand: ParsableCommand {
        public static var configuration = CommandConfiguration(
            commandName: "hash",
            abstract: "Perform cryptographically secure hashing."
        )

        @Option(name: .shortAndLong,
                default: .sha512,
                help: "\(Digest.algorithm) hash with the chosen digest.")
        public var digest: Digest

        @Argument(help: "Input string or file path.")
        public var input: String

        public var inputData: Data {
            do {
                return try data(input)
            } catch {
                return input.data
            }
        }

        public init() {}

        public func run() throws {
            print(digest.hash(inputData).bold)
            throw ExitCode.success
        }
    }
}

public extension Sequence where Self.Element == UInt8 {
    var string: String { compactMap { String(format: "%02x", $0) }.joined() }
}

public extension String {
    var data: Data { Data(utf8) }
    var hexData: Data {
        Data(stride(from: 0, to: count, by: 2).map {
            self[index(startIndex, offsetBy: $0) ... index(startIndex, offsetBy: $0 + 1)]
        }.map {
            UInt8($0, radix: 16)
        })
    }
}

public extension ParsableCommand {
    func string(_ path: String) throws -> String {
        return try Path(path).read()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func data(_ path: String) throws -> Data {
        let stringValue = try string(path)
        return stringValue.data
    }
}

public extension CryptoKitCLI {
    struct HMACCommand: ParsableCommand {
        public static var configuration = CommandConfiguration(
            commandName: "hmac",
            abstract: "Create or validate hash message authentication."
        )

        @Option(name: .shortAndLong,
                default: .sha512,
                help: "\(Digest.algorithm) hash with the chosen digest.")
        public var digest: Digest

        @Option(name: .shortAndLong,
                help: "Validate HMAC string or file path.")
        public var check: String?

        @Argument(help: "Symmetric key string or file path.")
        public var key: String

        @Argument(help: "Input string or file path.")
        public var input: String

        public var symmetricKey: SymmetricKey {
            do {
                return SymmetricKey(data: try data(key))
            } catch {
                return SymmetricKey(data: key.data)
            }
        }

        public var inputData: Data {
            do {
                return try data(input)
            } catch {
                return input.data
            }
        }

        public var checkString: String? {
            guard let checkPath = check else {
                return check
            }
            do {
                return try string(checkPath)
            } catch {
                return check
            }
        }

        public init() {}

        public func run() throws {
            guard let check = checkString else {
                let authenticationCode = digest.authenticationCode(data: inputData, key: symmetricKey)
                print(authenticationCode.bold)
                throw ExitCode.success
            }
            if digest.isValid(code: check.hexData, data: inputData, key: symmetricKey) {
                print("Valid".underline.green)
                throw ExitCode.success
            } else {
                print("Invalid".underline.red)
                throw ExitCode.failure
            }
        }
    }
}

CryptoKitCLI.main()
