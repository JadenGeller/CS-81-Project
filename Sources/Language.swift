//
//  Language.swift
//  Language
//
//  Created by Jaden Geller on 3/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley
import Expressive

//private let parseOperators = [
//    InfixOperator(characters: ["+"], precedence: 5, associativity: .Left),
//    InfixOperator(characters: ["*"], precedence: 6, associativity: .Left)
//]
//private let lexOperators = parseOperators + [
//    InfixOperator(characters: ["-", ">"], precedence: 1, associativity: .None),
//    InfixOperator(characters: [":", ":"], precedence: 1, associativity: .None),
//    InfixOperator(characters: ["="], precedence: 0, associativity: .None)
//]

let specification = OperatorSpecification(
    declarations: [
        OperatorDeclaration(symbol: "+", properties: .infix(precedence: 5, associativity: .left)),
        OperatorDeclaration(symbol: "*", properties: .infix(precedence: 6, associativity: .left)),
    ]
)

let lexOperators = specification.symbols + ["->", "::", "=", "(", ")"]

//
//func expressionConverter(expr: Expression) -> Expressive.Expression {
//    switch expr {
//    case .Lambda(let term, _, let value):
//        return Expressive.Expression.Capture(Expressive.Lambda.Implementation.Derived(argumentName: term.string, declarations: [], value: expressionConverter(value)))
//    case .Application(let lhs, let rhs):
//        return Expressive.Expression.Invoke(lambda: expressionConverter(lhs), argument: expressionConverter(rhs))
//    case .Lookup(let identifier):
//        switch identifier {
//        case .bare(let bare):
//            return Expressive.Expression.Lookup([bare.string])
//        case .infixOperator(let operatorValue):
//            return Expressive.Expression.Lookup([String(operatorValue.characters)])
//        }
//    case .literal(let literal):
//        switch literal {
//        case .Integer:
//            return Expressive.Expression.Return(Value(integerLiteral: Int(literal.description)!))
//        case .String:
//            return Expressive.Expression.Return(Value(stringLiteral: literal.description))
//        case .Decimal:
//            return Expressive.Expression.Return(Value(floatLiteral: Float(literal.description)!))
//        }
//    }
//}

public func lex(input: String) throws -> [Token] {
    return try LexingContext(symbols: lexOperators).lex(input)
}

public func parse(input: [Token]) throws -> Program {
    return try ParsingContext(operatorSpecification: specification).parse(input)
}

public func execute(program: String) throws {
    let program = try parse(lex(program))

    //    var bindings: [String: Expressive.Expression] = [:]
//    for statement in ast.bindings {
//        switch statement {
//        case .binding(let name, let expr):
//            bindings[name.string] = expressionConverter(expr)
//        }
//    }
//    
//    let program = Expressive.Program(declarations: bindings)
//    
//    program.run()
}
