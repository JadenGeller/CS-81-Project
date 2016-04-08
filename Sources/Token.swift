//
//  Lexing.swift
//  ProgrammingLanguage
//
//  Created by Jaden Geller on 10/26/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Parsley
import Spork

public enum Token {
    case symbol(Symbol)
    case bare(Bare)
    case literal(Literal)
    case newLine
}

extension Token: Equatable { }
public func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case let (.symbol(l), .symbol(r)):
        return l == r
    case let (.bare(l), .bare(r)):
        return l == r
    case let (.literal(l), .literal(r)):
        return l == r
    case (.newLine, .newLine):
        return true
    default: return false
    }
}

extension Token: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .symbol(let symbol):
            return symbol.description
        case .bare(let bare):
            return bare.description
        case .literal(let literal):
            return literal.description
        case .newLine:
            return "\\n"
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .symbol(let symbol):
            return "Token.symbol(\(symbol.description))"
        case .bare(let bare):
            return "Token.bare(\(bare.description))"
        case .literal(let literal):
            return "Token.literal(\(literal.description))"
        case .newLine:
            return "Token.newLine"
        }
    }
}
