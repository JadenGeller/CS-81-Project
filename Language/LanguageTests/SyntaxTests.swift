//
//  SyntaxTests.swift
//  Language
//
//  Created by Jaden Geller on 4/7/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Language
import Parsley
import Spork

class SyntaxTests: XCTestCase {
    
    func testLexToken() {
        XCTAssertEqual([
            .bare("let"), .bare("x"), .`operator`(.infix("=")), .delimiter("("), .bare("x"), .`operator`(.infix("::")), .bare("Int"), .delimiter(")"),
            .`operator`(.infix("->")), .bare("x"), .`operator`(.infix("*")), .bare("x"), .newLine,
            .bare("let"), .bare("y"), .`operator`(.infix("=")), .literal(3)
        ], try! lex("let x = (x :: Int) -> x * x\nlet y = 3"))
    }
    
    func testLexTokenExtraNewLine() {
        XCTAssertEqual([
            .bare("let"), .bare("x"), .`operator`(.infix("=")), .literal(1), .newLine,
            .bare("let"), .bare("x"), .`operator`(.infix("=")), .literal(2)
        ], try! lex("let x = 1\n\nlet x = 2"))
    }

    func testParserOperatorPrecedence() {
        XCTAssertEqual(Program(statements: [
            .binding("x", Expression.call(
                function: .identifier("+"),
                arguments: [
                    Expression.call(
                        function: .identifier("*"),
                        arguments: .literal(5), .literal(2)
                    ),
                    Expression.call(
                        function: .identifier("+"),
                        arguments: [
                            Expression.call(
                                function: .identifier("*"),
                                arguments: .literal(2), .literal(7)
                            ),
                            .literal(1)
                        ]
                    )
                ])
            )
            ]), try! parse(lex("let x = 5 * 2 + 2 * 7 + 1")))
    }
    
//    func testParsePrefixExpression() {
//        XCTAssertEqual(Program(statements: [
//            .binding("x", Expression.call(
//                function: .identifier("-"),
//                arguments: [
//                    Expression.call(
//                        function: .identifier("-"),
//                        arguments: .literal(5)
//                    ),
//                    Expression.call(
//                        function: .identifier("+"),
//                        arguments: [
//                            .literal(3),
//                            Expression.call(
//                                function: .identifier("-"),
//                                arguments: .literal(2)
//                            )
//                        ]
//                    )
//                ])
//            )
//            ]), try! parse(lex("let x = (-5 - 3) + -(-2)")))
//    }
    
    func testParseInfixFunction() {
        XCTAssertEqual(Program(statements: [
            .binding("x", Expression.call(
                function: .identifier("+"),
                arguments: [
                    Expression.call(function: .identifier("foo"), arguments: .literal(3)),
                    Expression.call(function: .identifier("bar"), arguments: .literal(5))
                ]
            ))
        ]), try! parse(lex("let x = foo 3 + bar 5")))
        
        XCTAssertEqual(Program(statements: [
            .binding("x", Expression.call(
                function: .identifier("foo"),
                arguments: [
                    Expression.literal(3),
                    Expression.identifier("+"),
                    Expression.identifier("bar"),
                    Expression.literal(5)
                ]
                ))
        ]), try! parse(lex("let x = foo 3 (+) bar 5")))

//        print(try! parse([.bare("let"), .bare("x"), .symbol("="), .symbol("("), .literal(5), .symbol("*"), .literal(3), .symbol(")")])) // broke :P
    }

//    func testParseStatement() {
//        print(try! terminating(Statement.parser(parseOperators)).parse(Token.lex(lexOperators, input: "let z = (x :: Int) -> (y :: Int) -> y + x * a \"hi\" 5.32")))
//    }
//    
//    func testParseProgram() {
//        print(try! terminating(Program.parser(parseOperators)).parse(Token.lex(lexOperators, input: "let w = 5\nlet z = (x :: Int) -> (y :: Int) -> y + x * a \"hi\" 5.32")))
//    }
}
