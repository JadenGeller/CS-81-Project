//
//  ConcreteType.swift
//  Language
//
//  Created by Jaden Geller on 4/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum ConcreteType: NilLiteralConvertible {
    case unknown
    case base(String)
    case derived(String, [ConcreteType])
    
    public init(nilLiteral: ()) {
        self = .unknown
    }
}

extension ConcreteType {
    static func function(lhs: ConcreteType, _ rhs: ConcreteType) -> ConcreteType {
        return .derived("Function", [lhs, rhs])
    }
    
    static var infixOperator: ConcreteType {
        return .function(.unknown, .function(.unknown, .unknown))
    }
}

extension ConcreteType: Equatable { }
public func ==(lhs: ConcreteType, rhs: ConcreteType) -> Bool {
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

extension ConcreteType: Hashable {
    public var hashValue: Int {
        switch self {
        case .unknown:
            return 0
        case .base(let name):
            return name.hashValue
        case .derived(let constructor, let arguments):
            return constructor.hashValue + arguments.reduce(0) { $0 ^ $1.hashValue }
        }
    }
}

extension ConcreteType: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "_"
        case .base(let name):
            return name
        case .derived(let constructor, let arguments):
            return "(" + constructor + " " + arguments.map{ $0.description }.joinWithSeparator(" ") + ")"
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .unknown:
            return "ConcreteType.unknown"
        case .base(let name):
            return "ConcreteType.base(\(name))"
        case .derived(let constructor, let arguments):
            return "ConcreteType.derived(\(constructor) \(arguments.map{ $0.description }.joinWithSeparator(" ")))"
        }
    }
}
