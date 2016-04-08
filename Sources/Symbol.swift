//
//  Symbol.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Symbol {
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
}

extension Symbol: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return text
    }
    
    public var debugDescription: String {
        return "Bare(\(description))"
    }
}

extension Symbol: StringLiteralConvertible {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Symbol: Equatable { }
public func ==(lhs: Symbol, rhs: Symbol) -> Bool {
    return lhs.text == rhs.text
}

extension Symbol {
    init?(token: Token) {
        guard case let .symbol(value) = token else { return nil }
        self.init(value.text)
    }
}
