//
//  Symbol.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public enum Symbol {
    case pairedDelimiter(PairedDelimiter)
    case infix(InfixOperator)
}

extension Symbol: Equatable {
    
}
public func ==(lhs: Symbol, rhs: Symbol) -> Bool {
    switch (lhs, rhs) {
    case (.pairedDelimiter(let l), .pairedDelimiter(let r)): return l == r
    case (.infix(let l), .infix(let r)): return l == r
    default: return false
    }
}

extension Symbol {
    public static func parser(infixOperators: [InfixOperator]) -> Parser<Character, Symbol> {
        return InfixOperator.parser(infixOperators).map(infix) ?? PairedDelimiter.parser.map(pairedDelimiter)
    }
    
    public static var all: [Symbol] {
        fatalError("Deprecated")
    }
}