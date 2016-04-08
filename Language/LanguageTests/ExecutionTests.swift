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
    func testRunProgram() {
        try! execute("let global.main.Void_Void = _ -> global.print.String_Void \"Hello world!\"") // -> Hello world!
        try! execute("let factorial = x -> global.if.Bool_[Void.T]_[Void.T]_T (global.equals.Int_Int_Bool 0 x) (_ -> 1) (_ -> global.multiply.Int_Int_Int x (factorial (global.add.Int_Int_Int x (global.negate.Int_Int_Int 1))))\nlet global.main.Void_Void = _ -> global.print.Int_Void (factorial 5)") // -> 120
    }
}