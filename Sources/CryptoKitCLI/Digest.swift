import ArgumentParser
import CryptoKit
import Foundation

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
