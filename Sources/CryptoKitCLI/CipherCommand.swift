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

    var symmetricKey: SymmetricKey {
        do {
            return SymmetricKey(data: try utf8Data(key))
        } catch {
            return SymmetricKey(data: key.utf8Data)
        }
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

    func run() throws {
        if tag != nil || decrypt {
            try decryptInput()
        } else {
            try encryptInput()
        }
    }
}
