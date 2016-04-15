//
//  TypeBoundExpression.swift
//  Language
//
//  Created by Jaden Geller on 4/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Gluey
import Axiomatic

public struct TypeBoundExpression: ExpressionType {
    public var node: ExpressionNode<TypeBoundExpression>
    public var binding: Binding<Term<ConcreteType>>
}

extension TypeBoundExpression: Equatable { }
public func ==(lhs: TypeBoundExpression, rhs: TypeBoundExpression) -> Bool {
    return lhs.node == rhs.node && lhs.binding == rhs.binding
}

extension TypeBoundExpression: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "(" + node.description + " :: #typeBinding(" + binding.description + "))"
    }
    
    public var debugDescription: String {
        return "TypeBoundExpression(\(node.debugDescription), binding: \(binding.description))"
    }
}