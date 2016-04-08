//
//  LexingContext.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/// Holds any state associated with the lexing process.
public struct LexingContext {
    public let symbols: [String]
    
    public init(symbols: [String]) {
        self.symbols = symbols
    }
}

extension LexingContext {
    /// Runs the lexer with the specified context.
    public func lex(input: String) throws -> [Token] {
        return try terminating(many(token.map(Optional.Some).recover{ _ in
            space.replace(nil)
        })).parse(input.characters).filter{ $0 != nil }.map{ $0! }
    }
}

import Parsley

// MARK: Token
extension LexingContext {
    /// Parses a token.
    var token: Parser<Character, Token> {
        return coalesce(
            literal.map(Token.literal),
            symbol.map(Token.symbol),
            bare.map(Token.bare),
            many1(newLine).replace(Token.newLine)
        )
    }
}

// MARK: Bare
extension LexingContext {
    /// Parses a bare word.
    var bare: Parser<Character, Bare> {
        return prepend(
            letter ?? character("_"),
            many(letter ?? digit ?? character("_") ?? character(".") ?? character("[") ?? character("]")) // TEMPORARY ADDITIONS
        ).withError("bareWord").stringify().map{ Bare($0) }
    }
}

// MARK: Symbol
extension LexingContext {
    /// Parses a symbol.
    var symbol: Parser<Character, Symbol> {
        return match(symbols){ Array($0.characters) }.map{ Symbol($0) }
    }
}

// MARK: Literal
extension LexingContext {
    /// Parses a positive or negative sign. In case of failure, it is as
    /// if a postive sign was successfully parsed.
    var sign: Parser<Character, Sign> {
        return match(Sign.all) { [$0.rawValue] }.otherwise(.Positive)
    }
    
    /// Parses 1 or more decimal digits.
    var decimalDigits: Parser<Character, [DecimalDigit]> {
        return many1(digit.map{ DecimalDigit(rawValue: Int(String($0))!)! })
    }
    
    /// Parses an integer literal.
    var integerLiteral: Parser<Character, Literal> {
        return pair(sign, decimalDigits).map(Literal.integer).withError("integer")
    }
    
    /// Parses a decimal literal.
    var decimalLiteral: Parser<Character, Literal> {
        return Parser { state in
            let sign = try self.sign.parse(state)
            let leftDigits = try self.decimalDigits.parse(state)
            _ = try character(".").parse(state)
            let rightDigits = try self.decimalDigits.parse(state)
            return .decimal(
                sign: sign,
                significand: leftDigits + rightDigits,
                exponent: -rightDigits.count
            )
        }.withError("decimal")
    }
    
    /// Parses a string literal.
    var stringLiteral: Parser<Character, Literal> {
        return between(character("\""), parseFew: any(), usingEscape: character("\\"))
            .stringify().map(Literal.string)
            .withError("string")
    }
    
    /// Parses any literal.
    var literal: Parser<Character, Literal> {
        // Must try decimal before integer since a integer prefixes a decimal.
        return stringLiteral ?? decimalLiteral ?? integerLiteral
    }
}
