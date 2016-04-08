//
//  Program.swift
//  Program
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

public struct Program {
    public var statements: [Statement]
}

extension Program: Equatable { }
public func ==(lhs: Program, rhs: Program) -> Bool {
    return lhs.statements == rhs.statements
}

extension Program: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return statements.map{ $0.description }.joinWithSeparator("\n")
    }
    
    public var debugDescription: String {
        return "Program(statements: \(statements))"
    }
}
