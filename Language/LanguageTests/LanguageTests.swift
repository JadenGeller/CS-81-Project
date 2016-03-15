//
//  LanguageTests.swift
//  LanguageTests
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Language
import Parsley
import Spork

class LanguageTests: XCTestCase {
    let operators = [
        InfixOperator(characters: ["+"], precedence: 5, associativity: .Left),
        InfixOperator(characters: ["*"], precedence: 6, associativity: .Left),
        InfixOperator(characters: [":", ":"], precedence: 2, associativity: .None),
        InfixOperator(characters: ["="], precedence: 0, associativity: .None),
        InfixOperator(characters: ["-", ">"], precedence: 1, associativity: .None)
    ]
    
    func testLexToken() {
        print(try! Token.lex(operators, input: "let x = (x :: Int) -> x * x"))
    }
    
    func testParseExpression() {
        print(try! terminating(Expression.parser(operators)).parse(Token.lex(operators, input: "y + x * a b c")))
    }
}
