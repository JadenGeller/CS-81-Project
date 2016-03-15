//
//  Expression.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum Identifier {
    case bare(Bare)
    case infixOperator(InfixOperator)
}

public enum Expression {
    indirect case Lambda(term: Bare, termType: String?, value: Expression)
    indirect case Application(Expression, Expression)
    case Lookup(Identifier)
    case literal(Literal)
}

extension Expression {
    public static func MultiApplication(expressions: [Expression]) -> Expression {
        precondition(!expressions.isEmpty)
        guard expressions.count > 1 else {
            return expressions[0]
        }
        return .Application(expressions.first!, MultiApplication(Array(expressions.dropFirst())))
    }
}

// MARK: Parsable

import Parsley

private let grouping = (token(Token.symbol(Symbol.pairedDelimiter(PairedDelimiter(rawValue: "(")!))), token(Token.symbol(Symbol.pairedDelimiter(PairedDelimiter(rawValue: ")")!))))
private let bare: Parser<Token, Bare> = any().map{ if case let .bare(b) = $0 where !["let"].contains(b.string) { return b } else { throw ParseError.UnableToMatch("Bare") } }
private let literalParser: Parser<Token, Literal> = any().map{ if case let .literal(l) = $0 { return l } else { throw ParseError.UnableToMatch("Literal") } }

private let arrowSymbol = InfixOperator(characters: ["-", ">"], precedence: 1, associativity: .None)
private let typeSymbol = InfixOperator(characters: [":", ":"], precedence: 1, associativity: .None)


extension Expression {
    init(infixOp: Infix<InfixOperator, Expression>) {
        switch infixOp {
        case .Expression(let op, let l, let r):
            self = Expression.Application(Expression.Application(Expression.Lookup(.infixOperator(op)), Expression(infixOp: l)),  Expression(infixOp: r))
        case .Value(let v):
            self = v
        }
    }
    
    private static func lambdaExpression(infixOperators: [InfixOperator]) -> Parser<Token, Expression> {
        // TODO: Clean up duplicate code
        return Parser { state in
            let arg = try bare.parse(state)
            
            _ = try token(Token.symbol(Symbol.infix(arrowSymbol))).parse(state)
            let expr = try looselyBoundExpression(infixOperators).parse(state)
            
            return Expression.Lambda(term: arg, termType: nil, value: expr)
        } ?? Parser { state in
            _ = try grouping.0.parse(state)
            let arg = try bare.parse(state)
            _ = try token(Token.symbol(Symbol.infix(typeSymbol))).parse(state)
            let type = try bare.parse(state)
            _ = try grouping.1.parse(state)
            
            _ = try token(Token.symbol(Symbol.infix(arrowSymbol))).parse(state)
            let expr = try looselyBoundExpression(infixOperators).parse(state)
            
            return Expression.Lambda(term: arg, termType: type.string, value: expr)
        }
    }
    
    private static func infixExpression(infixOperators: [InfixOperator]) -> Parser<Token, Expression> {
        
        let builder: InfixOperator -> Parser<Token, ()> = { token(Token.symbol(Symbol.infix($0))).discard() }
        return infix(infixOperators, operatorMatcherBuilder: builder, between: Expression.tightlyBoundExpression(infixOperators), groupedBy: grouping).map { Expression(infixOp: $0) }
    }
    
    // Identifier of function of 1+ args.
    private static func identifierExpression(infixOperators: [InfixOperator]) -> Parser<Token, Expression> {
        // Cannot left recurse on expression, must recurse on identifier
        return pair(bare.map(Identifier.bare).map(Expression.Lookup), many(hold(tightlyBoundExpression(infixOperators)))).map { lhs, rest in
            return Expression.MultiApplication([lhs] + rest)
        }
    }
    
    private static var literalExpression: Parser<Token, Expression> {
        return literalParser.map(Expression.literal)
    }
    
    private static func tightlyBoundExpression(infixOperators: [InfixOperator]) -> Parser<Token, Expression> {
        
        return identifierExpression(infixOperators) ?? literalExpression ?? between(grouping.0, grouping.1, parse: Expression.looselyBoundExpression(infixOperators))
    }
    
    private static func looselyBoundExpression(infixOperators: [InfixOperator]) -> Parser<Token, Expression> {
        // Must check for lambda first since it starts with an identifier (which will be parsed fine by infix expression leaving a dangling ->)
        return hold(lambdaExpression(infixOperators) ?? infixExpression(infixOperators))
    }
    
    public static func parser(infixOperators: [InfixOperator]) -> Parser<Token, Expression> {
        return Expression.looselyBoundExpression(infixOperators)
    }
}