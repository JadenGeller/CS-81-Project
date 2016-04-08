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
        try! execute([
            "let (*) = global.multiply.Int_Int_Int",
            "let (==) = global.equals.Int_Int_Bool",
            "let (+) = global.add.Int_Int_Int",
            "let if = global.if.Bool_[Void.T]_[Void.T]_T",
            "let negate = global.negate.Int_Int",
            "let factorial = x -> if (x == 0) (\\-> 1) (\\-> x * factorial (x + negate 1))",
            "let global.main.Void_Void = \\-> global.print.Int_Void (factorial 5)"
        ].joinWithSeparator("\n")) // -> 120
    }
}