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

        @Argument(help: "Input string to validate.")
        public var input: String?

        public init() {}

        public func run() throws {
            guard let input = input else {
                print("Universally unique value".underline)
                print(UUID().uuidString.bold)
                throw ExitCode.success
            }
            if let uuid = UUID(uuidString: input) {
                print("Valid".underline.green)
                print(uuid.uuidString.bold)
                throw ExitCode.success
            } else {
                print("Invalid".underline.red)
                print(input.bold)
                throw ExitCode.failure
            }
        }
    }
}

public enum Digest: String, ExpressibleByArgument {
    public static let algorithm = "SHA-2"
    public var bitCount: Int { Int(String(rawValue.suffix(3))) ?? 0 }

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
}

public extension HashFunction {
    static func hash(data: Data) -> String {
        hash(data: data).string
    }

    static func authenticationCode(data: Data, key: SymmetricKey) -> String {
        HMAC<Self>.authenticationCode(for: data, using: key).string
    }
}

public extension CryptoKitCLI {
    struct HashCommand: ParsableCommand {
        public static var configuration = CommandConfiguration(
            commandName: "hash",
            abstract: "Perform cryptographically secure hashing."
        )

        @Option(default: .sha512,
                help: "\(Digest.algorithm) hash with the chosen digest.")
        public var digest: Digest

        @Argument(help: "Input string or file path.")
        public var input: String

        public var inputData: Data {
            do {
                return try Path(input).read()
            } catch {
                return input.data
            }
        }

        public init() {}

        public func run() throws {
            print("\(Digest.algorithm) hash with a \(digest.bitCount)-bit digest".underline)
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
}

public extension CryptoKitCLI {
    struct HMACCommand: ParsableCommand {
        public static var configuration = CommandConfiguration(
            commandName: "hmac",
            abstract: "Hash message authentication algorithm."
        )

        @Option(default: .sha512,
                help: "\(Digest.algorithm) hash with the chosen digest.")
        public var digest: Digest

        @Argument(help: "Symmetric key string or file path.")
        public var key: String

        @Argument(help: "Input string or file path.")
        public var input: String

        public var symmetricKey: SymmetricKey {
            do {
                return SymmetricKey(data: try Path(key).read())
            } catch {
                return SymmetricKey(data: key.data)
            }
        }

        public var inputData: Data {
            do {
                return try Path(input).read()
            } catch {
                return input.data
            }
        }

        public init() {}

        public func run() throws {
            let authenticationCode = digest.authenticationCode(data: inputData, key: symmetricKey)
            print("Hash message authentication code".underline)
            print(authenticationCode.bold)
            throw ExitCode.success
        }
    }
}

CryptoKitCLI.main()
