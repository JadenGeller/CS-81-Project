//
//  Sign.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Sign: Character, Equatable {
    case Negative = "-"
    case Positive = "+"
}

extension Sign {
    public init(isPositive: Bool) {
        self = isPositive ? .Positive : .Negative
    }
    
    public static var all: [Sign] {
        return [.Negative, .Positive]
    }
}

public func ==(lhs: Sign, rhs: Sign) -> Bool {
    switch (lhs, rhs) {
    case (.Negative, .Negative): return true
    case (.Positive, .Positive): return true
    default: return false
    }
}

