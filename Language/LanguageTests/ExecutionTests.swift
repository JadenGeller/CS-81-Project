 //
//  ExecutionTests.swift
//  Language
//
//  Created by Jaden Geller on 4/7/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Language

class ExecutionTests: XCTestCase {
    func testHelloWorld() {
        try! execute("let global.main.Void_Void = \\-> global.print.String_Void \"Hello world!\"") // -> Hello world!
    }
    
    func testFactorial() {
        try! lex([
            "let (*) = global.multiply.Int_Int_Int",
            "let (==) = global.equals.Int_Int_Bool",
            "let (+) = global.add.Int_Int_Int",
            "let (-) = a -> b -> global.add.Int_Int_Int a (negate b)",
            "let if = global.if.Bool_[Void.T]_[Void.T]_T",
            "let negate = global.negate.Int_Int",
            "let print = global.print.Int_Void",
            "let ($) = f -> x -> f x",
            
            "let factorial = x -> if (x == 0) (\\-> 1) (\\-> x * factorial (x - 1))",
            "let main = \\-> print $ factorial 5",
            
            "let global.main.Void_Void = main"
        ].joinWithSeparator("\n")) // -> 120
    }
}