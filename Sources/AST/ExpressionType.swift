//
//  ExpressionType.swift
//  Language
//
//  Created by Jaden Geller on 4/15/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public protocol ExpressionType: Equatable, CustomStringConvertible, CustomDebugStringConvertible {
}

extension ExpressionType {
    public typealias Node = ExpressionNode<Self>
}