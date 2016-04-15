//
//  Expression.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Expression: ExpressionType {
    public var node: Expression.Node
    public var type: Type?
    
    public init(_ node: Expression.Node, type: Type? = nil) {
        self.node = node
        self.type = type
    }
}

extension Expression {
    // Use separate method, not default arguments, since we want to map.
    public static func lambda(value: Lambda<Expression>) -> Expression {
        return Expression(.lambda(value))
    }
    
    public static func application(value: Application<Expression>) -> Expression {
        return Expression(.application(value))
    }
    
    public static func identifier(value: Identifier) -> Expression {
        return Expression(.identifier(value))
    }
    
    public static func literal(value: Literal) -> Expression {
        return Expression(.literal(value))
    }
    
    public static func lambda(value: Lambda<Expression>, type: Type?) -> Expression {
        return Expression(.lambda(value), type: type)
    }
    
    public static func application(value: Application<Expression>, type: Type?) -> Expression {
        return Expression(.application(value), type: type)
    }
    
    public static func identifier(value: Identifier, type: Type?) -> Expression {
        return Expression(.identifier(value), type: type)
    }
    
    public static func literal(value: Literal, type: Type?) -> Expression {
        return Expression(.literal(value), type: type)
    }

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
    return lhs.node == rhs.node
}

extension Expression: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        if let type = type {
            return "(" + node.description + " :: " + type.description + ")"
        } else {
            return node.description
        }
    }
    
    public var debugDescription: String {
        if let type = type {
            return "Expression(\(node.debugDescription), type: \(type.debugDescription))"
        } else {
            return "Expression(\(node.debugDescription))"
        }
    }
}
