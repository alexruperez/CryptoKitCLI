import ArgumentParser
import CryptoKit
import Foundation

public struct ChaChaPolyCommand: CipherCommand {
    public static var configuration = CommandConfiguration(
        commandName: "poly",
        abstract: "Crypt and decrypt using ChaCha20-Poly1305 cipher."
    )

    @Option(name: .shortAndLong,
            help: "Nonce string or file path.")
    public var nonce: String?

    @Option(name: .shortAndLong,
            help: "Additional data string or file path.")
    public var auth: String?

    @Flag(name: .shortAndLong,
          help: "Decrypt the input and verify authenticity using combined data.")
    public var decrypt: Bool

    @Option(name: .shortAndLong,
          help: "Decrypt the input and verify authenticity using authentication tag and nonce.")
    public var tag: String?

    @Flag(name: .shortAndLong,
          help: "Print authentication tag and nonce instead of combined data.")
    public var split: Bool

    @Argument(help: "Symmetric key string or file path.")
    public var key: String

    @Argument(help: "Input string or file path.")
    public var input: String

    public init() {}

    public func nonceData<N: ContiguousBytes>() -> N? {
        guard let nonce = nonce else {
            return nil
        }
        do {
            return try ChaChaPoly.Nonce(data: try utf8Data(nonce)) as? N
        } catch {
            return try? ChaChaPoly.Nonce(data: nonce.utf8Data) as? N
        }
    }

    public func nonceHexData<N: ContiguousBytes>() -> N? {
        guard let nonce = nonce else {
            return nil
        }
        do {
            return try ChaChaPoly.Nonce(data: try hexData(nonce)) as? N
        } catch {
            return try? ChaChaPoly.Nonce(data: nonce.hexData) as? N
        }
    }

    public func validate() throws {
        if symmetricKey.bitCount != SymmetricKeySize.bits256.bitCount {
            print("Incorrect key size, only 256-bit key is allowed".underline.red)
            print("Tip: ".bold + "Key string length must be 32")
            throw ExitCode.validationFailure
        }
        if tag != nil && nonce == nil {
            print("You need a valid nonce to decrypt".underline.red)
            throw ExitCode.validationFailure
        }
    }

    public func encryptInput() throws {
        var sealedBox: ChaChaPoly.SealedBox!
        if let authData = authData {
            sealedBox = try ChaChaPoly.seal(inputData,
                                         using: symmetricKey,
                                         nonce: nonceData(),
                                         authenticating: authData)
        } else {
            sealedBox = try ChaChaPoly.seal(inputData,
                                         using: symmetricKey,
                                         nonce: nonceData())
        }
        if !split {
            print(sealedBox.combined.hexString.bold)
        } else {
            print("Cipher text".underline)
            print(sealedBox.ciphertext.hexString.bold)
            print("Nonce".underline)
            print(sealedBox.nonce.hexString)
            print("Tag".underline)
            print(sealedBox.tag.hexString.italic)
        }
        throw ExitCode.success
    }

    public func decryptInput() throws {
        var sealedBox: ChaChaPoly.SealedBox!
        if let tagHexData = tagHexData,
            let nonceHexData: ChaChaPoly.Nonce = nonceHexData() {
            sealedBox = try ChaChaPoly.SealedBox(nonce: nonceHexData,
                                              ciphertext: inputHexData,
                                              tag: tagHexData)
        } else {
            sealedBox = try ChaChaPoly.SealedBox(combined: inputHexData)
        }
        let data: Data!
        if let authData = authData {
            data = try ChaChaPoly.open(sealedBox,
                                    using: symmetricKey,
                                    authenticating: authData)
        } else {
            data = try ChaChaPoly.open(sealedBox,
                                    using: symmetricKey)
        }
        print(data.utf8String.bold)
        throw ExitCode.success
    }
}
