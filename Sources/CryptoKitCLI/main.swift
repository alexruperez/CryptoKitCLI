import ArgumentParser

/// CryptoKitCLI
public struct CryptoKitCLI: ParsableCommand {
    @Flag(help: "Show SwiftExecutableTemplate version.")
    var version: Bool

    /// Create CryptoKitCLI.
    public init() {}

    /// Run CryptoKitCLI.
    public func run() throws {
        guard !version else {
            print("CryptoKitCLI v0.1.0")
            return
        }
        print("Hello, CryptoKitCLI!")
    }
}

CryptoKitCLI.main()
