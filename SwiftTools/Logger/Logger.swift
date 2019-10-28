//
//  Logger.swift
//  SwiftTools
//
//  Created by alexej_ne on 28.10.2019.
//  Copyright © 2019 alexeyne. All rights reserved.
//

import Foundation

public protocol LoggerDelegate: class {
    func didRecieveLog(log: Logger.Log, loggerName: String)
}

public class Logger {
     
    public struct Analytic {
        public let name: String
        public let params: [String: Any]
        public let source: String?
        public let description: String?
        
        public init(name: String, params: [String: Any], source: String?, description: String?) {
            self.name = name
            self.params = params
            self.source = source
            self.description = description
        }
    }
    
    public enum Event {
        case unexpected(String)
        case analytic(Analytic)
        case error(Error)
    }
    
    public struct Log {
        public let event: Event
        public let file: String
        public let function: String
        public let line: UInt
        public let scope: String
        public let tag: String
        
        public init(event: Event, file: String = #file, function: String = #function, line: UInt = #line, scope: String = "", tag: String = "") {
            self.event = event
            self.file = file
            self.function = function
            self.line = line
            self.scope = scope
            self.tag = tag
        }
    }
    
    public weak var delegate: LoggerDelegate?
    
    public static let shared = Logger(name: "Shared")
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
    
    public func unexpected(_ message: String, file: String = #file, function: String = #function, line: UInt = #line, scope: String = "" , tag: String = "") {
        log(.unexpected(message), file: file, function: function, line: line, scope: scope, tag: tag)
    }
    
    public func analytic(_ analytic: Analytic, file: String = #file, function: String = #function, line: UInt = #line, scope: String = "" , tag: String = "") {
        log(.analytic(analytic), file: file, function: function, line: line, scope: scope, tag: tag)
    }
    
    public func error(_ error: Error, file: String = #file, function: String = #function, line: UInt = #line, scope: String = "" , tag: String = "") {
        log(.error(error), file: file, function: function, line: line, scope: scope, tag: tag)
    }
    
    public func log(_ event: Event, file: String = #file, function: String = #function, line: UInt = #line, scope: String = "" , tag: String = "") {
        let log = Log(event: event, file: file, function: function, line: line, scope: scope, tag: tag)
        self.log(log)
    }
    
    public func log(_ log: Log) {
        delegate?.didRecieveLog(log: log, loggerName: name)
    }
}

extension Logger.Log: CustomStringConvertible {
    public var description: String {
        let header: String
        
        switch event {
        case .analytic(let analityc): header = "ANALYTIC\n[\(analityc.name)] \(analityc)"
        case .error(let error): header = "ERROR\n[\(error)]"
        case .unexpected(let message): header = "UNEXPECTED\n[\(message)]"
        }
        
        return """
        \(header)
        file: \(file)
        function: \(function)
        line: \(line)
        scope: \(scope)
        tag: \(tag)
        """
    }
}