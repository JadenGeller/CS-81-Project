//
//  Delimiter.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Delimiter: String {
    case OpenParenthesis = "("
    case CloseParenthesis = ")"
}

extension Delimiter {
    public static let all: [Delimiter] = [.OpenParenthesis, .CloseParenthesis]
}

extension Delimiter: Equatable { }
public func ==(lhs: Delimiter, rhs: Delimiter) -> Bool {
    switch (lhs, rhs) {
    case (.OpenParenthesis, .OpenParenthesis):
        return true
    case (.CloseParenthesis, .CloseParenthesis):
        return true
    default:
        return false
    }
}

extension Delimiter: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return rawValue
    }
    
    public var debugDescription: String {
        switch self {
        case .OpenParenthesis:
            return "Delimiter.OpenParenthesis"
        case .CloseParenthesis:
            return "Delimiter.CloseParenthesis"
        }
    }
}

extension Delimiter: StringLiteralConvertible {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}

extension Delimiter {
    init?(token: Token) {
        guard case let .delimiter(value) = token else { return nil }
        self = value
    }
}
