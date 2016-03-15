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
    
    public enum Tag {
        case symbol
        case bare
        case literal
        case newLine
    }
    public var tag: Tag {
        switch self {
        case .symbol:  return .symbol
        case .bare:    return .bare
        case .literal: return .literal
        case .newLine: return .newLine
        }
    }
}

extension Token.Tag: Equatable { }
public func ==(lhs: Token.Tag, rhs: Token.Tag) -> Bool {
    switch (lhs, rhs) {
    case (.symbol, .symbol): return true
    case (.bare, .bare): return true
    case (.literal, .literal): return true
    case (.newLine, .newLine): return true
    default: return false
    }
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

extension Token {
    public static func parser(infixOperators: [InfixOperator]) -> Parser<Character, Token> {
        return Symbol.parser(infixOperators).map(symbol) ?? Literal.parser.map(literal) ?? Bare.parser.map(bare) ?? many1(Parsley.newLine).replace(Token.newLine)
    }
    
    public static func lex(infixOperators: [InfixOperator], input: String) throws -> [Token] {
        // TODO: Do this in a more clean way than optionals.
        let results = try terminating(many(parser(infixOperators).map(Optional.Some) ?? space.replace(Optional.None))).parse(input.characters)
        return results.filter{ $0 != nil }.map{ $0! }
    }
}

//struct Operator {
//    let symbol: String
//}
//
//extension Operator: Matchable {
//    static var all: [Operator] = [Operator(symbol: "+"), Operator(symbol: <#T##String#>)]
//    
//    var matcher: Parser<Character, ()> {
//        return string(symbol).discard()
//    }
//}
//
//let terminatorCharacter: Character = ";"
//
//enum ControlFlowSymbol {
//    case Nested(PairedDelimiter)
//    case Terminator
//    case Infix(Operator)
//}
//
//extension ControlFlowSymbol: Matchable {
//    static var all = PairedDelimiter.all.map(ControlFlowSymbol.Nested) + [.Terminator] + Operator.all.map(ControlFlowSymbol.Infix)
//    
//    var matcher: Parser<Character, ()> {
//        switch self {
//        case .Nested(let pairedDelimiter): return pairedDelimiter.matcher
//        case .Terminator:                  return character(terminatorCharacter).discard()
//        case .Infix(let infixOperator):    return infixOperator.matcher
//        }
//    }
//}
//
//enum Token {
//    case Bare(String)
//    case Literal(LiteralValue)
//    case Flow(ControlFlow)
//}
//
//extension Token: Parsable {
//    private static let bareWord = prepend(
//        letter ?? character("_"),
//        many(letter ?? digit ?? character("_"))
//        ).stringify().withError("bareWord")
//    
//    static var parser = LiteralValue.parser.map(Token.Literal) ?? ControlFlow.parser.map(Token.Flow) ?? bareWord.map(Token.Bare)
//}
//

