//
//  BuchheimsWalkerData.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 22.02.2024.
//

import Foundation

class BuchheimsWalkerData {
    var prelim = 0.0
    var modifier = 0.0
    var shift = 0.0
    var change = 0.0
    var number = 0
    var depth = 0
    var ancestor: Node?
    var thread: Node?
    var predecessorNodes: [Node] = []
    var successorNodes: [Node] = []
}
