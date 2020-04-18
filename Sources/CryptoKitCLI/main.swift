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
        subcommands: [UUIDCommand.self,
                      HashCommand.self,
                      HMACCommand.self,
                      AESCommand.self,
                      ChaChaPolyCommand.self]
    )

    public init() {}
}

CryptoKitCLI.main()
