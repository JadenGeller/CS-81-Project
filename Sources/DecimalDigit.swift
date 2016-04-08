//
//  DecimalDigit.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum DecimalDigit: Int, Equatable {
    case Zero
    case One
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
    case Nine
}

extension DecimalDigit: IntegerLiteralConvertible {
    public init(integerLiteral value: Int) {
        guard let this = DecimalDigit(rawValue: value) else {
            fatalError("Decimal digit must be between 0 and 9")
        }
        self = this
    }
}

public func ==(lhs: DecimalDigit, rhs: DecimalDigit) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
