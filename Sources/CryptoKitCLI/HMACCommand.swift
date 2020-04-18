import ArgumentParser
import CryptoKit
import Foundation

public struct HMACCommand: ParsableCommand {
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

    public var symmetricKey: SymmetricKey {
        do {
            return SymmetricKey(data: try utf8Data(key))
        } catch {
            return SymmetricKey(data: key.utf8Data)
        }
    }

    public var inputData: Data {
        do {
            return try utf8Data(input)
        } catch {
            return input.utf8Data
        }
    }

    public init() {}

    public func run() throws {
        guard let check = checkString else {
            let authenticationCode = digest.authenticationCode(data: inputData, key: symmetricKey)
            print(authenticationCode.hexString.bold)
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
