//
//  Logger.swift
//  modules
//
//  Created by Krzysiek on 2025-02-25.
//
import Foundation
import OSLog

nonisolated(unsafe) public var globalLogLevel: CLogger.LogLevel?

// MARK: - Log
public struct CLogger: Sendable {
    // MARK: Nested Types
    public enum LogLevel: Int, Sendable, CaseIterable {
        case debug
        case info
        case event
        case warning
        case error

        // MARK: Computed Properties
        public var prefix: String {
            switch self {
            case .debug:
                "DEBUG 🐞"
            case .info:
                "INFO ℹ️"
            case .event:
                "EVENT ⏱"
            case .warning:
                "WARNING ⚠️"
            case .error:
                "ERROR 💥"
            }
        }
    }

    // MARK: Properties
    public let logger: Logger?

    let level: LogLevel?

    // MARK: Lifecycle
    public init(
        logLevel: LogLevel? = nil,
        prefix: String = "modules",
        category: String
    ) {
        self.level = logLevel

        if let bundleName = Bundle.main.bundleIdentifier {
            self.logger = Logger(subsystem: bundleName, category: "\(prefix)_\(category)")
        } else {
            self.logger = nil
        }
    }

    // MARK: Functions
    public func debug(_ message: String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function)
    {
        _log(logLevel: .debug, message: message, file: file, line: line, function: function)
    }

    public func info(_ message: String,
                     file: String = #fileID,
                     line: Int = #line,
                     function: String = #function)
    {
        _log(logLevel: .info, message: message, file: file, line: line, function: function)
    }

    public func event(_ message: String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function)
    {
        _log(logLevel: .event, message: message, file: file, line: line, function: function)
    }

    public func warning(_ message: String,
                        file: String = #fileID,
                        line: Int = #line,
                        function: String = #function)
    {
        _log(logLevel: .warning, message: message, file: file, line: line, function: function)
    }

    public func error(_ message: String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function)
    {
        _log(logLevel: .error, message: message, file: file, line: line, function: function)
    }

    private func _log(logLevel: LogLevel,
                      message: String,
                      file: String = #fileID,
                      line: Int = #line,
                      function: String = #function)
    {
        guard let basicLevel = level ?? globalLogLevel, logLevel.rawValue >= basicLevel.rawValue else { return }

        let message = "[\(logLevel.prefix)] \(file) - \(String(describing: function)) - Line: \(line) -> \(message)"

        switch logLevel {
        case .debug: logger?.debug("\(message, privacy: .public)")
        case .info: logger?.info("\(message, privacy: .public)")
        case .event: logger?.notice("\(message, privacy: .public)")
        case .warning: logger?.warning("\(message, privacy: .public)")
        case .error: logger?.error("\(message, privacy: .public)")
        }
    }
}
