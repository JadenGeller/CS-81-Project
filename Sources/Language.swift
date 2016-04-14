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


extension Expressive.Expression {
    init(expression: Language.Expression) {
        switch expression {
        case .lambda(let lambda):
            self = Expressive.Expression.Capture(Expressive.Lambda.Implementation.Derived(argumentName: lambda.argumentName?.name, declarations: [], value: Expressive.Expression(expression: lambda.implementation)))
        case .application(let application):
            self = Expressive.Expression.Invoke(
                lambda: Expressive.Expression(expression: application.function),
                argument: Expressive.Expression(expression: application.argument
            ))
        case .identifier(let identifier):
            self = Expressive.Expression.Lookup([identifier.name])
        case .literal(let literal):
            // THIS IS GROSS, CLEAN IT UP
            switch literal {
            case .integer:
                self = Expressive.Expression.Return(Value(integerLiteral: Int(literal.description)!))
            case .string:
                self = Expressive.Expression.Return(Value(stringLiteral: literal.description))
            case .decimal:
                self = Expressive.Expression.Return(Value(floatLiteral: Float(literal.description)!))
            }
        }
    }
}

let specification = OperatorSpecification(
    declarations: [
        OperatorDeclaration(symbol: "-", properties: .init(precedence: 5, associativity: .left)),
        OperatorDeclaration(symbol: "==", properties: .init(precedence: 5, associativity: .left)),
        OperatorDeclaration(symbol: "+", properties: .init(precedence: 5, associativity: .left)),
        OperatorDeclaration(symbol: "*", properties: .init(precedence: 6, associativity: .left)),
        OperatorDeclaration(symbol: "$", properties: .init(precedence: 0, associativity: .left)),
        //        OperatorDeclaration(symbol: "~", properties: .prefix),
        //        OperatorDeclaration(symbol: "!", properties: .prefix),
        //        OperatorDeclaration(symbol: "%", properties: .postfix)
    ]
)

let lexOperators = (specification.symbols + ["->", "\\->", "::", "=", "(", ")", "[", "]", ".", "~"]).sort {
    $0.characters.count > $1.characters.count // try longer ones first
}

public func lex(input: String) throws -> [Token] {
    return try LexingContext(symbols: lexOperators).lex(input)
}

public func parse(input: [Token]) throws -> Program {
    return try ParsingContext(operatorSpecification: specification).parse(input)
}

public func execute(program: String) throws {
    let tokens = try lex(program)
    print("TOKENS:", tokens.map{ $0.description }.joinWithSeparator(" "))
    let ast = try parse(tokens)
    print("AST:", ast.description)
    
    var bindings: [String: Expressive.Expression] = [:]
    for statement in ast.statements {
        switch statement {
        case .binding(let identifier, let expression):
            bindings[identifier.name] = Expressive.Expression(expression: expression)
        }
    }
    
    let program = Expressive.Program(declarations: bindings)
    
    program.run()
}
