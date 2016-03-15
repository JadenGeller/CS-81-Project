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

private let parseOperators = [
    InfixOperator(characters: ["+"], precedence: 5, associativity: .Left),
    InfixOperator(characters: ["*"], precedence: 6, associativity: .Left)
]
private let lexOperators = parseOperators + [
    InfixOperator(characters: ["-", ">"], precedence: 1, associativity: .None),
    InfixOperator(characters: [":", ":"], precedence: 1, associativity: .None),
    InfixOperator(characters: ["="], precedence: 1, associativity: .None)
]

class LanguageTests: XCTestCase {
    
    func testLexToken() {
        print(try! Token.lex(lexOperators, input: "let x = (x :: Int) -> x * x"))
    }
    
    func testParseExpression() {
        print(try! terminating(Expression.parser(parseOperators)).parse(Token.lex(lexOperators, input: "x -> y -> y + x * a b c")))
    }
}
