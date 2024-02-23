//
//  Edge.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 22.02.2024.
//

import Foundation

open class Edge: Hashable, Equatable {
    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        lhs.source == rhs.source && lhs.destination == rhs.destination
    }

    var source: Node
    var destination: Node

    public init(source: Node, destination: Node) {
        self.source = source
        self.destination = destination
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(destination)
    }
}
