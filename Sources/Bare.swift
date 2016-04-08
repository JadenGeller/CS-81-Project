//
//  Bare.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Bare {
    public let text: String
    
    public init(_ text: String) {
        self.text = text
    }
}

extension Bare: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return text
    }
    
    public var debugDescription: String {
        return "Bare(\(description))"
    }
}

extension Bare: StringLiteralConvertible {
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

extension Bare: Equatable { }
public func ==(lhs: Bare, rhs: Bare) -> Bool {
    return lhs.text == rhs.text
}

extension Bare {
    init?(token: Token) {
        guard case let .bare(value) = token else { return nil }
        self.init(value.text)
    }
}

