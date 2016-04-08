//
//  LiteralValue.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Darwin

public enum Literal {
    case integer(sign: Sign, digits: [DecimalDigit])
    case decimal(sign: Sign, significand: [DecimalDigit], exponent: Int)
    case string(String)
}

extension Literal: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        self = .integer(
            sign: Sign(isPositive: value > 0),
            digits: abs(value).description.characters.map{ DecimalDigit(rawValue: Int(String($0))!)! }
        )
    }
}

extension Literal: StringLiteralConvertible {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension Literal: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .integer(let sign, let digits):
            return String(sign.rawValue) + (digits.map{ String($0.rawValue) }).joinWithSeparator("")
        case .decimal(let sign, let significand, let exponent):
            return (Float(Literal.integer(sign: sign, digits: significand).description)! * pow(10, Float(exponent))).description
        case .string(let string):
            return string
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .integer(let sign, let digits):
            return "Literal.integer(sign: \(sign), digits: \(digits))"
        case .decimal(let sign, let significand, let exponent):
            return "Literal.decimal(sign: \(sign), significand: \(significand), exponent: \(exponent))"
        case .string(let string):
            return "Literal.string(\"\(string)\")"
        }
    }
}

extension Literal: Equatable { }
public func ==(lhs: Literal, rhs: Literal) -> Bool {
    switch (lhs, rhs) {
    case let (.integer(lsign, ldigits), .integer(rsign, rdigits)):
        return lsign == rsign && ldigits == rdigits
    case let (.decimal(lsign, lsignificant, lexponent), .decimal(rsign, rsignificant, rexponent)):
        return lsign == rsign && lsignificant == rsignificant && lexponent == rexponent
    case let (.string(l), .string(r)):
        return l == r
    default: return false
    }
}

extension Literal {
    init?(token: Token) {
        guard case let .literal(value) = token else { return nil }
        self = value
    }
}
