//
//  Program.swift
//  Program
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public struct Program {
    public var bindings: [Statement]
}

extension Program {
    public static func parser(infixOperators: [InfixOperator]) -> Parser<Token, Program> {
        return separatedBy(Statement.parser(infixOperators), delimiter: token(Token.newLine)).map(Program.init)
    }
}