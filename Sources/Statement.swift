//
//  Statement.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public enum Statement {
    case binding(Bare, Expression)
}

private let equalSymbol = InfixOperator(characters: ["="], precedence: 0, associativity: .None)

private let letParser: Parser<Token, Bare> = any().map{ if case let .bare(b) = $0 where b.string == "let" { return b } else { throw ParseError.UnableToMatch("Let") } }
private let bare: Parser<Token, Bare> = any().map{ if case let .bare(b) = $0 where !["let"].contains(b.string) { return b } else { throw ParseError.UnableToMatch("Bare") } }

extension Statement {
    public static func parser(infixOperators: [InfixOperator]) -> Parser<Token, Statement> {
        return Parser { state in
            _ = try letParser.parse(state)
            let name = try bare.parse(state)
            _ = try token(Token.symbol(Symbol.infix(equalSymbol))).parse(state)
            let expr = try Expression.parser(infixOperators).parse(state)

            return Statement.binding(name, expr)
        }
    }
}