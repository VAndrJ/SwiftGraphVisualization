//
//  NumberNode.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 22.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import SwiftGraphVisualization

class NumberNode: Node {
    let number: Int

    init(number: Int) {
        self.number = number

        super.init()
    }
}
