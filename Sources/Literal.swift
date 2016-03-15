//
//  LiteralValue.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

// TODO: Rename to follow modern Swift.
public enum Literal {
    case Integer(sign: Sign, digits: [DecimalDigit])
    case Decimal(sign: Sign, significand: [DecimalDigit], exponent: Int)
    case String(Swift.String)
}

extension Literal: Equatable {
    
}
public func ==(lhs: Literal, rhs: Literal) -> Bool {
    switch (lhs, rhs) {
    case let (.Integer(lsign, ldigits), .Integer(rsign, rdigits)):
        return lsign == rsign && ldigits == rdigits
    case let (.Decimal(lsign, lsignificant, lexponent), .Decimal(rsign, rsignificant, rexponent)):
        return lsign == rsign && lsignificant == rsignificant && lexponent == rexponent
    case let (.String(l), .String(r)):
        return l == r
    default: return false
    }
}

// MARK: Parsable

import Parsley

extension Literal: Parsable {
    private static let sign = Sign.parser.otherwise(.Positive)
    private static let digits = many1(DecimalDigit.parser)
    
    private static let integer = pair(sign, digits)
        .map(Literal.Integer)
        .withError("integer")
    
    private static let decimal = Parser<Character, Literal> { state in
        let theSign = try sign.parse(state)
        let leftDigits = try digits.parse(state)
        let decimal = try character(".").parse(state)
        let rightDigits = try digits.parse(state)
        return .Decimal(
            sign: theSign,
            significand: leftDigits + rightDigits,
            exponent: -rightDigits.count
        )
    }.withError("decimal")
    
    private static let string = between(character("\""), parseFew: any(), usingEscape: character("\\"))
        .stringify().map(Literal.String)
        .withError("stringLiteral")
    
    public static var parser = decimal ?? integer ?? string
}
