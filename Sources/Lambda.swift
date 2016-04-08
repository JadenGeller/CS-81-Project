//
//  Lambda.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Lambda {
    public var argumentName: Identifier
    public var implementation: Expression
}

extension Lambda: Equatable { }
public func ==(lhs: Lambda, rhs: Lambda) -> Bool {
    return lhs.argumentName == rhs.argumentName && lhs.implementation == rhs.implementation
}

extension Lambda: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return argumentName.description + " -> " + implementation.description
    }
    
    public var debugDescription: String {
        return "Lambda(argumentName: \(argumentName.debugDescription), implementation: \(implementation.debugDescription))"
    }
}