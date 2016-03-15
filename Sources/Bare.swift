//
//  Bare.swift
//  Language
//
//  Created by Jaden Geller on 2/22/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Bare {
    public let string: String
}

import Parsley

extension Bare: Parsable {
    public static let parser = prepend(
        letter ?? character("_"),
        many(letter ?? digit ?? character("_"))
    ).stringify().withError("bareWord").map(Bare.init)

}

extension Bare: Equatable { }
public func ==(lhs: Bare, rhs: Bare) -> Bool {
    return lhs.string == rhs.string
}