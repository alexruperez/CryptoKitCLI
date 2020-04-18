import ArgumentParser
import CryptoKit
import Foundation

public enum Digest: String, Decodable, ExpressibleByArgument {
    public static let algorithm = "SHA-2"
    public var bitCount: Int { Int(rawValue.suffix(3)) ?? 0 }

    case sha512
    case sha384
    case sha256

    public func hash(_ data: Data) -> Data {
        switch self {
        case .sha512:
            return Data(SHA512.hash(data: data))
        case .sha384:
            return Data(SHA384.hash(data: data))
        case .sha256:
            return Data(SHA256.hash(data: data))
        }
    }

    public func authenticationCode(data: Data, key: SymmetricKey) -> Data {
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
