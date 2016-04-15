//
//  Type.swift
//  Language
//
//  Created by Jaden Geller on 4/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Type: NilLiteralConvertible {
    case unknown
    case base(String)
    case derived(String, [Type])
    
    public init(nilLiteral: ()) {
        self = .unknown
    }
}

extension Type {
    static func function(lhs: Type, _ rhs: Type) -> Type {
        return .derived("Function", [lhs, rhs])
    }
}

extension Type: Equatable { }
public func ==(lhs: Type, rhs: Type) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
        return true
    case (.base(let l), .base(let r)):
        return l == r
    case (.derived(let l1, let l2), .derived(let r1, let r2)):
        return l1 == r1 && l2 == r2
    case (.unknown, _), (.base, _), (.derived, _):
        return false
    }
}

extension Type: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "?"
        case .base(let name):
            return name
        case .derived(let functor, let arguments):
            return "(" + functor + arguments.map{ $0.description }.joinWithSeparator(" ") + ")"
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "Type.unknown"
        case .base(let name):
            return "Type.base(\(name))"
        case .derived(let functor, let arguments):
            return "Type.derived(\(functor) \(arguments.map{ $0.description }.joinWithSeparator(" ")))"
        }
    }
}
