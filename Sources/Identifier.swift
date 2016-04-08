//
//  Identifier.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/// Type representing values that can be looked up by name.
public enum Identifier {
    case bare(Bare)
    case symbol(Symbol)
}

extension Identifier {
    public var text: String {
        switch self {
        case .bare(let bare):
            return bare.text
        case .symbol(let symbol):
            return symbol.text
        }
    }
}

extension Identifier: Equatable { }
public func ==(lhs: Identifier, rhs: Identifier) -> Bool {
    switch (lhs, rhs) {
    case (.bare(let l), .bare(let r)):
        return l == r
    case (.symbol(let l), .symbol(let r)):
        return l == r
    default:
        return false
    }
}

extension Identifier: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .bare(let bare):
            return bare.description
        case .symbol(let symbol):
            return "(" + symbol.description + ")"
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .bare(let bare):
            return "Bare(\(bare.description))"
        case .symbol(let symbol):
            return "Symbol(\(symbol.description))"
        }
    }
}
