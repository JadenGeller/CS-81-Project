//
//  ParsingContext.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

/// Holds any state associated with the parsing process.
public struct ParsingContext {
    public let operatorSpecification: OperatorSpecification<String>
    private let symbols: Set<String>
    public let keywords: Set = ["let"]
    
    public init(operatorSpecification: OperatorSpecification<String>) {
        self.operatorSpecification = operatorSpecification
        self.symbols = Set(operatorSpecification.symbols)
    }
}

extension ParsingContext {
    /// Runs the parser with the specified context.
    public func parse(input: [Token]) throws -> Program {
        return try terminating(program).parse(input)
    }
}

import Parsley

// MARK: Expression
extension ParsingContext {
    
    /// Parses an expression.
    var expression: Parser<Token, Expression> {
        return looselyBoundExpression
    }
    
    /// Parses a loosely bound expression. This is any sort of expression,
    /// even a tightly bound one.
    var looselyBoundExpression: Parser<Token, Expression> {
        // Must check for lambda first since it starts with an identifier (which will
        // be parsed fine by infix expression leaving a dangling right arrow and
        // lambda implementation).
        return hold(coalesce(
            self.lambda.map(Expression.lambda),
            self.infixExpression
        ))
    }
    
    /// Parses a tightly bound expression. This is any type of expression 
    /// that doesn't have ambiguity in this context.
    var tightlyBoundExpression: Parser<Token, Expression> {
        return coalesce(
            // Don't parse `callExpression` here else we'll infinite loop.
            identifierExpression,
            literalExpression,
            between(parenthesis.left, parenthesis.right, parse: looselyBoundExpression)
        )
    }
    
    /// Parses an infix operator expression tree.
    var infixExpression: Parser<Token, Expression> {
        return operatorExpression(
            parsing: callExpression,
            groupedBy: parenthesis,
            usingSpecification: operatorSpecification,
            matching: { string in
                convert{ Symbol(token: $0) }
                    .require{ $0.text == string }
                    .map(Identifier.symbol)
                    .map(Expression.identifier)
            }
        ).map(Expression.init)
    }
    
    /// Parses a left or right parenthesis.
    var parenthesis: (left: Parser<Token, Token>, right: Parser<Token, Token>) {
        return (left: token(.symbol("(")), right: token(.symbol(")")))
    }
    
    /// Parses an literal expression.
    var literalExpression: Parser<Token, Expression> {
        return convert{ Literal(token: $0) }.map(Expression.literal)
    }
    
    /// Parses a symbol surrounded by parenthesis.
    var identifierExpression: Parser<Token, Expression> {
        return bareIdentifierExpression ?? symbolIdentifierExpression
    }
    
    /// Parses a symbol surrounded by parenthesis.
    var symbolIdentifierExpression: Parser<Token, Expression> {
        return between(parenthesis.left, parenthesis.right, parse: symbolIdentifier.map(Expression.identifier))
    }
    
    /// Parses a bare.
    var bareIdentifierExpression: Parser<Token, Expression> {
        return bareIdentifier.map(Expression.identifier)
    }
}

// MARK: Identifier
extension ParsingContext {
    
    /// Parses a bare word as an identifier.
    var bareIdentifier: Parser<Token, Identifier> {
        return convert{ Bare(token: $0) }
            .require{ !self.keywords.contains($0.text) }
            .map(Identifier.bare)
    }
    
    /// Parses a symbol as an identifier.
    var symbolIdentifier: Parser<Token, Identifier> {
        return convert{ Symbol(token: $0) }
            .require{ self.symbols.contains($0.description) }
            .map(Identifier.symbol)
    }
}

// MARK: Lambda
extension ParsingContext {
    
    /// Parses a lambda.
    var lambda: Parser<Token, Lambda> {
        return Parser { state in
            let argumentName = try bare.parse(state)
            _ = try token(Token.symbol("->")).parse(state)
            let implementation = try self.looselyBoundExpression.parse(state)
            
            return Lambda(argumentName: .bare(argumentName), implementation: implementation)
        }
    }
}

// MARK: Application
extension ParsingContext {
    
    /// Parses a function call.
    private var callExpression: Parser<Token, Expression> {
        // Cannot left recurse with top-down parser. Thus, we must use a combinator.
        return many1(tightlyBoundExpression).map{ values in
            Expression.call(function: values.first!, arguments: Array(values.dropFirst()))
        }
    }
}

// MARK: Statement
extension ParsingContext {
    
    /// Parses the keyword let.
    func keyword(word: String) -> Parser<Token, ()> {
        return convert{ Bare(token: $0) }.require{ $0.text == word }.discard()
    }
    
    /// Parses a statement.
    var statement: Parser<Token, Statement> {
        return Parser { state in
            _ = try self.keyword("let").parse(state)
            let name = try bare.parse(state)
            _ = try token(.symbol("=")).parse(state)
            let value = try self.expression.parse(state)
            
            return Statement.binding(.bare(name), value)
        }
    }
}

// MARK: Program
extension ParsingContext {
    
    /// Parses an entire program.
    var program: Parser<Token, Program> {
        return separated(by: statement, delimiter: token(Token.newLine)).map(Program.init)
    }
}


private let bare: Parser<Token, Bare> = any().map{ if case let .bare(b) = $0 where !["let"].contains(b.text) { return b } else { throw ParseError.UnableToMatch("Bare") } }

extension Expression {
    init(infixOp: OperatorExpression<String, Expression>) {
        switch infixOp {
        case .infix(let op, let (l, r)):
            self = Expression.call(
                function: Expression.identifier(Identifier.symbol(Symbol(op))),
                arguments: [
                    Expression(infixOp: l),
                    Expression(infixOp: r)
                ]
            )
        case .value(let v):
            self = v
        }
    }
}
