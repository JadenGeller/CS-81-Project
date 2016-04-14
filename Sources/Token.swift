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
    case `operator`(Operator)
    case delimiter(Delimiter)
    case bare(Bare)
    case literal(Literal)
    case newLine
}

extension Token: Equatable { }
public func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case let (.`operator`(l), .`operator`(r)):
        return l == r
    case let (.bare(l), .bare(r)):
        return l == r
    case let (.literal(l), .literal(r)):
        return l == r
    case let (.delimiter(l), .delimiter(r)):
        return l == r
    case (.newLine, .newLine):
        return true
    default: return false
    }
}

extension Token: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .`operator`(let symbol):
            return symbol.description
        case .delimiter(let delimiter):
            return delimiter.description
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
        case .`operator`(let symbol):
            return "Token.symbol(\(symbol.debugDescription))"
        case .delimiter(let delimiter):
            return "Token.delimiter(\(delimiter.debugDescription))"
        case .bare(let bare):
            return "Token.bare(\(bare.debugDescription))"
        case .literal(let literal):
            return "Token.literal(\(literal.debugDescription))"
        case .newLine:
            return "Token.newLine"
        }
    }
}
