//
//  Node.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 22.02.2024.
//

import Foundation
import CoreGraphics

open class Node: Hashable, Equatable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.id == rhs.id
    }

    public let id = UUID()
    public var origin: CGPoint = .zero
    public var size: CGSize
    public var width: CGFloat {
        get { size.width }
        set { size.width = newValue }
    }
    public var height: CGFloat {
        get { size.height }
        set { size.height = newValue }
    }
    public var x: CGFloat {
        get { origin.x }
        set { origin.x = newValue }
    }
    public var y: CGFloat {
        get { origin.y }
        set { origin.y = newValue }
    }

    public init(size: CGSize = .zero) {
        self.size = size
    }

    open func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
