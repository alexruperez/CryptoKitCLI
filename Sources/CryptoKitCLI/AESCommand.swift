import ArgumentParser
import CryptoKit
import Foundation

public struct AESCommand: CipherCommand {
    public static var configuration = CommandConfiguration(
        commandName: "aes",
        abstract: "Crypt and decrypt using AES-GCM cipher."
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

    public var allowedKeyBytes: [Int] {
        [16, 24, 32]
    }

    public func nonceData<N: ContiguousBytes>() -> N? {
        guard let nonce = nonce else {
            return nil
        }
        do {
            return try AES.GCM.Nonce(data: try utf8Data(nonce)) as? N
        } catch {
            return try? AES.GCM.Nonce(data: nonce.utf8Data) as? N
        }
    }

    public func nonceHexData<N: ContiguousBytes>() -> N? {
        guard let nonce = nonce else {
            return nil
        }
        do {
            return try AES.GCM.Nonce(data: try hexData(nonce)) as? N
        } catch {
            return try? AES.GCM.Nonce(data: nonce.hexData) as? N
        }
    }

    public func encryptInput() throws {
        var sealedBox: AES.GCM.SealedBox!
        if let authData = authData {
            sealedBox = try AES.GCM.seal(inputData,
                                         using: symmetricKey,
                                         nonce: nonceData(),
                                         authenticating: authData)
        } else {
            sealedBox = try AES.GCM.seal(inputData,
                                         using: symmetricKey,
                                         nonce: nonceData())
        }
        if let combinedData = sealedBox.combined, !split {
            print(combinedData.hexString.bold)
        } else {
            print("Cipher text".underline)
            print(sealedBox.ciphertext.hexString.bold)
            print("Nonce".underline)
            print(sealedBox.nonce.hexString)
            print("Tag".underline)
            print(sealedBox.tag.hexString.italic)
        }
    }

    public func decryptInput() throws {
        var sealedBox: AES.GCM.SealedBox!
        if let tagHexData = tagHexData,
            let nonceHexData: AES.GCM.Nonce = nonceHexData() {
            sealedBox = try AES.GCM.SealedBox(nonce: nonceHexData,
                                              ciphertext: inputHexData,
                                              tag: tagHexData)
        } else {
            sealedBox = try AES.GCM.SealedBox(combined: inputHexData)
        }
        let data: Data!
        if let authData = authData {
            data = try AES.GCM.open(sealedBox,
                                    using: symmetricKey,
                                    authenticating: authData)
        } else {
            data = try AES.GCM.open(sealedBox,
                                    using: symmetricKey)
        }
        print(data.utf8String.bold)
    }
}
