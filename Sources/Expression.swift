//
//  Expression.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Expression {
    indirect case lambda(Lambda)
    indirect case application(Application)
    case identifier(Identifier)
    case literal(Literal)
}

extension Expression {
    public static func call(function function: Expression, arguments: Expression...) -> Expression {
        return call(function: function, arguments: arguments)
    }
    
    public static func call(function function: Expression, arguments: [Expression]) -> Expression {
        guard !arguments.isEmpty else { return function }
        return call(
            function: .application(Application(function: function, argument: arguments.first!)),
            arguments: Array(arguments.dropFirst())
        )
    }
}

extension Expression: Equatable { }
public func ==(lhs: Expression, rhs: Expression) -> Bool {
    switch (lhs, rhs) {
    case (.lambda(let l), .lambda(let r)):
        return l == r
    case (.application(let l), .application(let r)):
        return l == r
    case (.identifier(let l), .identifier(let r)):
        return l == r
    case (.literal(let l), .literal(let r)):
        return l == r
    default:
        return false
    }
}

extension Expression: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .lambda(let lambda):
            return lambda.description
        case .application(let application):
            return application.description
        case .identifier(let identifier):
            return identifier.description
        case .literal(let literal):
            return literal.description
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .lambda(let lambda):
            return lambda.debugDescription
        case .application(let application):
            return application.debugDescription
        case .identifier(let identifier):
            return identifier.debugDescription
        case .literal(let literal):
            return literal.debugDescription
        }
    }
}
