//
//  Operator.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Operator {
    public var text: String
    public var spacing: TokenSpacing
    
    public init(_ text: String, withSpacing spacing: TokenSpacing) {
        self.text = text
        self.spacing = spacing
    }
}

extension Operator {
    public var alignment: TokenAlignment? {
        return TokenAlignment(spacing: spacing)
    }
}

extension Operator {
    public init(_ text: String, withAlignment alignment: TokenAlignment) {
        self.init(text, withSpacing: TokenSpacing(alignment: alignment))
    }
    
    public static func infix(text: String) -> Operator {
        return Operator(text, withAlignment: .infix)
    }
    
    public static func prefix(text: String) -> Operator  {
        return Operator(text, withAlignment: .prefix)
    }
    
    public static func postfix(text: String) -> Operator  {
        return Operator(text, withAlignment: .postfix)
    }
}

extension Operator: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return text
    }
    
    public var debugDescription: String {
        return "Operator(text: \(text), spacing: \(spacing))"
    }
}

extension Operator: Equatable { }
public func ==(lhs: Operator, rhs: Operator) -> Bool {
    return lhs.text == rhs.text && lhs.spacing == rhs.spacing
}

extension Operator {
    init?(token: Token) {
        guard case let .`operator`(value) = token else { return nil }
        self = value
    }
}
