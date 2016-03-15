//
//  PairedDelimiter.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public struct PairedDelimiter {
    public let symbol: Symbol
    public let facing: Facing
    
    public enum Symbol {
        case Parenthesis
        case CurlyBracket
    }
    public enum Facing {
        case Open
        case Close
    }
}

extension PairedDelimiter.Symbol: Enumeratable {
    public static var all: [PairedDelimiter.Symbol] = [.Parenthesis, .CurlyBracket]
}

extension PairedDelimiter.Facing: Enumeratable {
    public static var all: [PairedDelimiter.Facing] = [.Open, .Close]
}

extension PairedDelimiter: Matchable {
    public var characterValue: Character {
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

    public static var all = Symbol.all.flatMap{ symbol in
        Facing.all.map{ facing in
            return PairedDelimiter(symbol: symbol, facing: facing)
        }
    }

    public var matcher: Parser<Character, ()> {
        return character(characterValue).discard()
    }
}

extension PairedDelimiter: RawRepresentable {
    public init?(rawValue: Character) {
        switch rawValue {
        case "(": self = PairedDelimiter(symbol: .Parenthesis, facing: .Open)
        case ")": self = PairedDelimiter(symbol: .Parenthesis, facing: .Close)
        case "{": self = PairedDelimiter(symbol: .CurlyBracket, facing: .Open)
        case "}": self = PairedDelimiter(symbol: .CurlyBracket, facing: .Close)
        default: return nil
        }
    }
    
    public var rawValue: Character {
        return characterValue
    }
}

extension PairedDelimiter: Equatable { }
public func ==(lhs: PairedDelimiter, rhs: PairedDelimiter) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

