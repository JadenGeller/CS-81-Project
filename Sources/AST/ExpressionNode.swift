//
//  ExpressionNode.swift
//  Language
//
//  Created by Jaden Geller on 4/14/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum ExpressionNode<Expression: ExpressionType> {
    indirect case lambda(Lambda<Expression>)
    indirect case application(Application<Expression>)
    case identifier(Identifier)
    case literal(Literal)
}

extension ExpressionNode: Equatable { }
public func ==<Expression: ExpressionType>(lhs: ExpressionNode<Expression>, rhs: ExpressionNode<Expression>) -> Bool {
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

extension ExpressionNode: CustomStringConvertible, CustomDebugStringConvertible {
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
