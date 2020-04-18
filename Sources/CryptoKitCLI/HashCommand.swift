import ArgumentParser
import Foundation

public struct HashCommand: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "hash",
        abstract: "Perform cryptographically secure hashing."
    )

    @Option(name: .shortAndLong,
            default: .sha512,
            help: "\(Digest.algorithm) hash with the chosen digest.")
    public var digest: Digest

    @Argument(help: "Input string or file path.")
    public var input: String

    public var inputData: Data {
        do {
            return try utf8Data(input)
        } catch {
            return input.utf8Data
        }
    }

    public init() {}

    public func run() throws {
        print(digest.hash(inputData).hexString.bold)
        throw ExitCode.success
    }
}
