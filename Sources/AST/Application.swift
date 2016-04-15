//
//  Application.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Application<Expression: ExpressionType> {
    public var function: Expression
    public var argument: Expression
}

extension Application: Equatable { }
public func ==<Expression: ExpressionType>(lhs: Application<Expression>, rhs: Application<Expression>) -> Bool {
    return lhs.function == rhs.function && lhs.argument == rhs.argument
}

extension Application: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "(" + function.description + " " + argument.description + ")"
    }
    
    public var debugDescription: String {
        return "Application(function: \(function.debugDescription), argument: \(argument.debugDescription))"
    }
}