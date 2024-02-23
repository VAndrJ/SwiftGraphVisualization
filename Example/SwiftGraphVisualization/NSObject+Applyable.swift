//
//  NSObject+Applyable.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 23.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import Foundation

public protocol Applyable {}

extension Applyable where Self: AnyObject {
    @discardableResult
    func apply(_ f: (Self) throws -> Void) rethrows -> Self {
        try f(self)

        return self
    }
}

extension NSObject: Applyable {}
