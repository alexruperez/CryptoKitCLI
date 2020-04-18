import ArgumentParser
import CryptoKit
import Foundation

public protocol CipherCommand: ParsableCommand {
    static var configuration: CommandConfiguration { get }

    var nonce: String? { get }
    var auth: String? { get }
    var decrypt: Bool { get }
    var tag: String? { get }
    var split: Bool { get }
    var key: String { get }
    var input: String { get }

    var authData: Data? { get }
    var tagHexData: Data? { get }
    var allowedKeyBytes: [Int] { get }
    var symmetricKey: SymmetricKey { get }
    var inputData: Data { get }
    var inputHexData: Data { get }

    func nonceData<N: ContiguousBytes>() -> N?
    func nonceHexData<N: ContiguousBytes>() -> N?
    func validate() throws
    func encryptInput() throws
    func decryptInput() throws
    func run() throws
}

public extension CipherCommand {
    var authData: Data? {
        guard let auth = auth else {
            return nil
        }
        do {
            return try utf8Data(auth)
        } catch {
            return auth.utf8Data
        }
    }

    var tagHexData: Data? {
        guard let tag = tag else {
            return nil
        }
        do {
            return try hexData(tag)
        } catch {
            return tag.hexData
        }
    }

    var allowedKeyBytes: [Int] {
        [32]
    }

    var symmetricKey: SymmetricKey {
        var keyData: Data!
        do {
            keyData = try utf8Data(key)
        } catch {
            keyData = key.utf8Data
        }
        if !allowedKeyBytes.contains(keyData.count) {
            keyData = Digest.sha256.hash(keyData)
        }
        return SymmetricKey(data: keyData)
    }

    var inputData: Data {
        do {
            return try utf8Data(input)
        } catch {
            return input.utf8Data
        }
    }

    var inputHexData: Data {
        do {
            return try hexData(input)
        } catch {
            return input.hexData
        }
    }

    func validate() throws {
        if tag != nil, nonce == nil {
            print("You need a valid nonce to decrypt".underline.red)
            throw ExitCode.validationFailure
        }
    }

    func run() throws {
        do {
            if tag != nil || decrypt {
                try decryptInput()
            } else {
                try encryptInput()
            }
        } catch let error as CryptoKitError {
            print("Error".underline.red)
            switch error {
            case .incorrectKeySize:
                print("A key is being deserialized with an incorrect key size.")
            case .incorrectParameterSize:
                print("The number of bytes passed for a given argument is incorrect.")
            case .authenticationFailure:
                print("The authentication tag or signature is incorrect.")
            case let .underlyingCoreCryptoError(errorCode):
                print("An unexpected error \(errorCode) at a lower-level occured.")
            @unknown default:
                print(error.localizedDescription)
            }
            throw ExitCode.failure
        } catch {
            print("Error".underline.red)
            print(error.localizedDescription)
            throw ExitCode.failure
        }
        throw ExitCode.success
    }
}
