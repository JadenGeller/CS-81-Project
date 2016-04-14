//
//  TokenSpacing.swift
//  Language
//
//  Created by Jaden Geller on 4/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct TokenSpacing {
    public var hasLeadingSpace: Bool
    public var hasTrailingSpace: Bool
    
    public init(hasLeadingSpace: Bool, hasTrailingSpace: Bool) {
        self.hasLeadingSpace = hasLeadingSpace
        self.hasTrailingSpace = hasTrailingSpace
    }
}

extension TokenSpacing: Equatable { }
public func ==(lhs: TokenSpacing, rhs: TokenSpacing) -> Bool {
    return lhs.hasLeadingSpace == rhs.hasLeadingSpace && lhs.hasTrailingSpace == rhs.hasTrailingSpace
}

extension TokenSpacing {
    public init(alignment: TokenAlignment) {
        switch alignment {
        case .infix:
            self.init(hasLeadingSpace: true, hasTrailingSpace: true)
        case .prefix:
            self.init(hasLeadingSpace: true, hasTrailingSpace: false)
        case .postfix:
            self.init(hasLeadingSpace: false, hasTrailingSpace: true)
        }
    }
}
