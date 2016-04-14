//
//  Identifier.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/// Type representing values that can be looked up by name.
public struct Identifier {
    public var name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

extension Identifier: StringLiteralConvertible {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

//extension Identifier {
//    public var text: String {
//        switch self {
//        case .bare(let bare):
//            return bare.text
//        case .`operator`(let symbol):
//            return symbol.text
//        }
//    }
//}

extension Identifier: Equatable { }
public func ==(lhs: Identifier, rhs: Identifier) -> Bool {
    return lhs.name == rhs.name
}

extension Identifier: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return name
//        switch self {
//        case .bare(let bare):
//            return bare.description
//        case .`operator`(let symbol):
//            return "(" + symbol.description + ")"
//        }
    }
    
    public var debugDescription: String {
        return "Identifier(\"\(name)\")"
//        switch self {
//        case .bare(let bare):
//            return "Bare(\(bare.description))"
//        case .`operator`(let symbol):
//            return "Symbol(\(symbol.description))"
//        }
    }
}
