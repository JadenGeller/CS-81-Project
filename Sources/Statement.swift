//
//  Statement.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public enum Statement {
    case binding(Identifier, Expression)
}

extension Statement: Equatable { }
public func ==(lhs: Statement, rhs: Statement) -> Bool {
    switch (lhs, rhs) {
    case (.binding(let lIdentifier, let lExpression), .binding(let rIdentifier, let rExpression)):
        return lIdentifier == rIdentifier && lExpression == rExpression
    }
}

extension Statement: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .binding(let identifier, let expression):
            return "let \(identifier) = \(expression)"
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .binding(let identifier, let expression):
            return "Statement.binding(\(identifier), \(expression))"
        }
    }
}
