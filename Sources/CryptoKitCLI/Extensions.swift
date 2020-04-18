import ArgumentParser
import CryptoKit
import Foundation
import PathKit

public extension HashFunction {
    static func hash(data: Data) -> String {
        hash(data: data).hexString
    }

    static func authenticationCode(data: Data, key: SymmetricKey) -> String {
        HMAC<Self>.authenticationCode(for: data, using: key).hexString
    }

    static func isValid(code: Data, data: Data, key: SymmetricKey) -> Bool {
        HMAC<Self>.isValidAuthenticationCode(code, authenticating: data, using: key)
    }
}

public extension Sequence where Self.Element == UInt8 {
    var utf8String: String { String(data: Data(self), encoding: .utf8) ?? "" }
    var hexString: String { compactMap { String(format: "%02x", $0) }.joined() }
}

public extension String {
    var utf8Data: Data { Data(utf8) }
    var hexData: Data {
        Data(stride(from: 0, to: count, by: 2).map {
            self[index(startIndex, offsetBy: $0) ... index(startIndex, offsetBy: $0 + 1)]
        }.compactMap {
            UInt8($0, radix: 16)
        })
    }
}

public extension ParsableCommand {
    func string(_ path: String) throws -> String {
        return try Path(path).read()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func utf8Data(_ path: String) throws -> Data {
        let stringValue = try string(path)
        return stringValue.utf8Data
    }

    func hexData(_ path: String) throws -> Data {
        let stringValue = try string(path)
        return stringValue.hexData
    }
}
