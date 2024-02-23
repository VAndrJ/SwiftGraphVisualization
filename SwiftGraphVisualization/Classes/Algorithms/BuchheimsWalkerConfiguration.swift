//
//  BuchheimsWalkerConfiguration.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 22.02.2024.
//

import Foundation
import CoreGraphics

public class BuchheimsWalkerConfiguration {
    public var orientation: GraphOrientation
    public var neighbourSpacing: Double
    public var levelSpacing: Double
    public var subtreeSpacing: Double
    public var nodeSize: CGSize

    public init(
        orientation: GraphOrientation = .topToBottom,
        neighbourSeparation: Double = 42,
        levelSeparation: Double = 42,
        subtreeSeparation: Double = 42,
        nodeSize: CGSize = .init(width: 42, height: 42)
    ) {
        self.orientation = orientation
        self.neighbourSpacing = neighbourSeparation
        self.levelSpacing = levelSeparation
        self.subtreeSpacing = subtreeSeparation
        self.nodeSize = nodeSize
    }
}
