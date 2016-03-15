//
//  InfixOperator.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public struct InfixOperator: InfixOperatorType, Equatable {
    public let characters: [Character]
    public var precedence: Int
    public var associativity: Associativity
}

// TODO: I don't think using "Parsable" protocols is a good approach because it doesn't add anything
//       in terms of safety, and it actively discourages dynamic behavior. For example, if we are to
//       first lex the document to determine what symbols exist, we can't use this protocol.

public func ==(lhs: InfixOperator, rhs: InfixOperator) -> Bool {
    return lhs.characters == rhs.characters && lhs.precedence == rhs.precedence && lhs.associativity == rhs.associativity
}

extension InfixOperator: RawRepresentable {
    public init?(rawValue: [Character]) {
        fatalError()
    }

    public var rawValue: [Character] {
        return characters
    }
}

extension InfixOperator {
    public static func parser(infixOperators: [InfixOperator]) -> Parser<Character, InfixOperator> {
        return coalesce(infixOperators.sort{ $0.characters.count > $1.characters.count }.map(raw))
    }
    
    public static var all: [InfixOperator] {
        fatalError("Deprecated")
    }
    
    public var matcher: Parser<Character, ()> {
        fatalError("Deprecated")
    }
    
//    func parser(symbols: [Symbol]) -> Parser<Character, Symbol> {
//        return Parser { state in
//            for symbol in symbols.sort({ $0.characters.count > $1.characters.count }) {
//                do {
//                    try sequence(symbol.characters.map(token)).parse(state)
//                    return symbol
//                } catch {
//                    continue
//                }
//            }
//            throw ParseError.UnableToMatch("Symbol(\(symbols))")
//        }
//    }
}