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

public func ==(lhs: DecimalDigit, rhs: DecimalDigit) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

// MARK: Parsable

import Parsley

extension DecimalDigit: Parsable {
    public static let parser = digit.map{ DecimalDigit(rawValue: Int(String($0))!)! }
}