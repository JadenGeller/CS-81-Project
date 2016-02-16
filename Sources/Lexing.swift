//
//  Lexing.swift
//  ProgrammingLanguage
//
//  Created by Jaden Geller on 10/26/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Parsley

enum Sign: Character {
    case Negative = "-"
    case Positive = "+"
}

extension Sign: Matchable {
    static var all: [Sign] = [.Negative, .Positive]
    
    var matcher: Parser<Character, ()> {
        return character(rawValue).discard()
    }
}

enum LiteralValue {
    case IntegerLiteral(sign: Sign, digits: DigitList)
    case FloatingPointLiteral(sign: Sign, significand: DigitList, exponent: Int)
    case StringLiteral(String)
}

extension LiteralValue: Parsable {
    private static let sign = Sign.parser.otherwise(.Positive)
    
    private static let digits = many1(digit)
        .stringify()
        .map(DigitList.init).map{ $0! }
    
    private static let integerLiteral = pair(sign, digits)
        .map(LiteralValue.IntegerLiteral)
        .withError("integerLiteral")
    
    private static let floatingPointLiteral = Parser<Character, LiteralValue> { state in
        let theSign = try sign.parse(state)
        let leftDigits = try digits.parse(state)
        let decimal = try character(".").parse(state)
        let rightDigits = try digits.parse(state)
        return .FloatingPointLiteral(sign: theSign, significand: leftDigits + rightDigits, exponent: -rightDigits.digits.count)
    }
    
    private static let stringLiteral = between(character("\""), parseFew: any(), usingEscape: character("\\"))
        .stringify()
        .map(LiteralValue.StringLiteral)
    
    static var parser = floatingPointLiteral ?? integerLiteral ?? stringLiteral
}

enum Operator: String {
    case Assignment = ":="
    case Lambda = "->"
    case Binding = "::"
}

extension Operator: Matchable {
    static var all: [Operator] = [.Assignment, .Lambda, .Binding]
    
    var matcher: Parser<Character, ()> {
        return string(rawValue).discard()
    }
}

let terminatorCharacter: Character = ";"

enum ControlFlowSymbol {
    case Nested(PairedDelimiter)
    case Terminator
    case Infix(Operator)
}

extension ControlFlowSymbol: Matchable {
    static var all = PairedDelimiter.all.map(ControlFlow.Nested) + [.Terminator] + Operator.all.map(ControlFlow.Infix)
    
    var matcher: Parser<Character, ()> {
        switch self {
        case .Nested(let pairedDelimiter): return pairedDelimiter.matcher
        case .Terminator:                  return character(terminatorCharacter).discard()
        case .Infix(let infixOperator):    return infixOperator.matcher
        }
    }
}

enum Token {
    case Bare(String)
    case Literal(LiteralValue)
    case Flow(ControlFlow)
}

extension Token: Parsable {
    private static let bareWord = prepend(
        letter ?? character("_"),
        many(letter ?? digit ?? character("_"))
        ).stringify().withError("bareWord")
    
    static var parser = LiteralValue.parser.map(Token.Literal) ?? ControlFlow.parser.map(Token.Flow) ?? bareWord.map(Token.Bare)
}

struct PairedDelimiter {
    let symbol: Symbol
    let facing: Facing

    enum Symbol {
        case Parenthesis
        case CurlyBracket
    }
    enum Facing {
        case Open
        case Close
    }
}

extension PairedDelimiter.Symbol: Enumerable {
    static var all: [Symbol] = [.Parenthesis, .CurlyBracket]
}

extension PairedDelimiter.Facing: Enumerable {
    static var all: [Facing] = [.Open, .Close]
}

extension PairedDelimiter: Matchable {
    var characterValue: Character {
        switch symbol {
        case .Parenthesis:
            switch facing {
            case .Open:  return "("
            case .Close: return ")"
            }
        case .CurlyBracket:
            switch facing {
            case .Open:  return "{"
            case .Close: return "}"
            }
        }
    }
    
    static var all = Symbol.all.flatMap{ symbol in
        Facing.all.map{ facing in
            return PairedDelimiter(symbol: symbol, facing: facing)
        }
    }
    
    var matcher: Parser<Character, ()> {
        return character(characterValue).discard()
    }
}
