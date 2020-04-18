import ArgumentParser
import Foundation

public struct UUIDCommand: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "uuid",
        abstract: "Create or validate a universally unique value."
    )

    @Option(name: .shortAndLong,
            help: "Validate UUID string or file path.")
    public var check: String?

    public var checkString: String? {
        guard let checkPath = check else {
            return check
        }
        do {
            return try string(checkPath)
        } catch {
            return check
        }
    }

    public init() {}

    public func run() throws {
        guard let check = checkString else {
            print(UUID().uuidString.bold)
            throw ExitCode.success
        }
        if UUID(uuidString: check) != nil {
            print("Valid".underline.green)
            throw ExitCode.success
        } else {
            print("Invalid".underline.red)
            throw ExitCode.failure
        }
    }
}
