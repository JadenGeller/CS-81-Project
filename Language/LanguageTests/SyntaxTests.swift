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
            .bare("let"), .bare("x"), .symbol("="), .symbol("("), .bare("x"), .symbol("::"), .bare("Int"), .symbol(")"),
            .symbol("->"), .bare("x"), .symbol("*"), .bare("x"), .newLine,
            .bare("let"), .bare("y"), .symbol("="), .literal(3)
        ], try! lex("let x = (x :: Int) -> x * x\nlet y = 3"))
    }
    
    func testLexTokenExtraNewLine() {
        XCTAssertEqual([
            .bare("let"), .bare("x"), .symbol("="), .literal(1), .newLine,
            .bare("let"), .bare("x"), .symbol("="), .literal(2)
        ], try! lex("let x = 1\n\nlet x = 2"))
    }

    func testParseExpression() {
//        print(try! parse(lex("let x = foo 3 + bar 5")))
//        print(try! parse(lex("let x = foo 3 (+) bar 5")))
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
