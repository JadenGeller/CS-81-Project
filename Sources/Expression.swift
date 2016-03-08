//
//  Expression.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Expression {
    indirect case Lambda(term: Identifier, value: Expression)
    case Application(Expression, Expression)
    indirect case Binding(Identifier, Expression)
    case Lookup(Identifier)
}

// MARK: Parsable

import Parsley

extension Expression: Parsable {
//    private static let identifierDeclaration = either ( identifier 
}