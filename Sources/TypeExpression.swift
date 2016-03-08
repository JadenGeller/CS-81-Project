//
//  TypeExpression.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum TypeExpression {
    case Concrete(Type)
    case Application(lambda: TypeExpression, argument: TypeExpression)
}

// Array Int
// Dictionary Int Int