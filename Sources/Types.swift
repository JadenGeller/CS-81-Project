//
//  Identifier.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import Parsley

//public enum InfixOperator: InfixOperatorType, Matchable {
//    case Plus
//    
//    public var precedence: Int { return 0 }
//    public var associativity: Associativity { return Associativity.Left }
//    public static var all = [InfixOperator.Plus]
//    
//    public var matcher: Parser<Character, ()> { return character("+").discard() }
//}

//public enum Expression: Parsable {
//    indirect case Application(function: Expression, argument: Expression)
//    case Lookup(Identifier)
//    case Operator(InfixOperator)
//    
//    init(infixOp: Infix<InfixOperator, Expression>) {
//        switch infixOp {
//        case .Expression(let op, let l, let r):
//            self = Expression.Application(function: Expression.Application(function: Expression.Operator(op), argument: Expression(infixOp: l)), argument: Expression(infixOp: r))
//        case .Value(let v):
//            self = v
//        }
//    }
//    
//    private static let infixExpression: Parser<Character, Expression> = infix(InfixOperator.self, between: Expression.tightlyBoundExpression, groupedBy: (character("("), character(")"))).map { Expression(infixOp: $0) }
//    
//    private static let tightlyBoundExpression = Identifier.parser.map(Expression.Lookup) ?? between(character("("), character(")"), parse: Expression.looselyBoundExpression)
//    private static let looselyBoundExpression = Expression.infixExpression
//    
//    public static let parser = Expression.looselyBoundExpression
//}


// TREE TYPES

//struct Program {
//    var statements: [Declaration]
//}
//
//enum Statement {
//    case declaration(Declaration)
//}
//
//struct Declaration {
//    var mutable: Bool
//    var identifier: Identifier
//    var value: Expression
//}
//
//indirect enum Expression {
//    case application(Application)
//    case lambda(Lambda)
//    case identifier(Identifier)
//    case literal(Literal)
//}
//
//struct Application {
//    var function: Expression
//    var argument: Expression
//}
//
//struct Lambda {
//    var argument: Identifier
//    var implementation: Expression
//}
//
//struct Identifier {
//    let name: String
//}
//
//// MARK: Parsable
//
//extension Expression: Parsable {
//    private static let tightlyBoundExpression: Parser<Character, Expression> = Identifier.parser.map(Expression.identifier) ?? between(character("("), character(")"), parse: Expression.looselyBoundExpression)
//    private static let looselyBoundExpression: Parser<Character, Expression> = Lambda.parser.map(Expression.lambda) ?? Application.parser.map(Expression.application) ?? hold(Expression.tightlyBoundExpression)
//    
//    static let parser = Expression.looselyBoundExpression
//}
//
//extension Lambda: Parsable {
//    static let parser = Parser<Character, Lambda> { state in
//        try character("\\").parse(state)
//        let identifier = try Identifier.parser.parse(state)
//        
//    }
//}
//
//extension Application: Parsable {
//    static let parser = pair(Expression.looselyBoundExpression, Expression.tightlyBoundExpression).map(Application.init)
//}
//
//extension Identifier: Parsable {
//    static let parser = many(digit ?? letter).map{ Identifier(name: String($0)) }
//}


