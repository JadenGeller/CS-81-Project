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

public func ==(lhs: Sign, rhs: Sign) -> Bool {
    switch (lhs, rhs) {
    case (.Negative, .Negative): return true
    case (.Positive, .Positive): return true
    default: return false
    }
}

// MARK: Matchable

import Parsley

extension Sign: Matchable {
    public static var all: [Sign] = [.Negative, .Positive]
    
    public var matcher: Parser<Character, ()> {
        return character(rawValue).discard()
    }
}