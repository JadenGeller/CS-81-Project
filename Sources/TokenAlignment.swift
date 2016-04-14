//
//  TokenAlignment.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public enum TokenAlignment {
    case infix
    case prefix
    case postfix
}

extension TokenAlignment: Equatable { }
public func ==(lhs: TokenAlignment, rhs: TokenAlignment) -> Bool {
    switch (lhs, rhs) {
    case (.infix, .infix):
        return true
    case (.prefix, .prefix):
        return true
    case (.postfix, .postfix):
        return true
    default:
        return false
    }
}

extension TokenAlignment {
    public init?(spacing: TokenSpacing) {
        switch (spacing.hasLeadingSpace, spacing.hasTrailingSpace) {
        case (true, true):
            self = .infix
        case (true, false):
            self = .prefix
        case (false, true):
            self = .postfix
        default:
            return nil
        }
    }
}
