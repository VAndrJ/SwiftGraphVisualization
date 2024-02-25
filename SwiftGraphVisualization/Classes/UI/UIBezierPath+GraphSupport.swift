//
//  UIBezierPath+GraphSupport.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 23.02.2024.
//

import UIKit

// TBD
public enum LinesConfiguration {
    case straight
    case rightAngles(anchor: CGFloat = 0.5)
    case straightTop(anchor: CGFloat = 0.5)
    case straightBottom(anchor: CGFloat = 0.5)
}

public extension UIBezierPath {

    convenience init(
        configuration: BuchheimsWalkerConfiguration,
        graph: Graph,
        linesConfiguration: LinesConfiguration = .rightAngles()
    ) {
        self.init()

        self.init(
            orientation: configuration.orientation,
            levelSpacing: configuration.levelSpacing,
            graph: graph,
            linesConfiguration: linesConfiguration
        )
    }

    convenience init(
        orientation: GraphOrientation,
        levelSpacing: CGFloat,
        graph: Graph,
        linesConfiguration: LinesConfiguration = .rightAngles()
    ) {
        self.init()

        var shouldAddFirst: Bool
        var shouldAddSecond: Bool
        let lineSpacing: CGFloat
        switch linesConfiguration {
        case let .rightAngles(anchor):
            assert(0...1 ~= anchor)

            shouldAddFirst = true
            shouldAddSecond = true
            lineSpacing = levelSpacing * anchor
        case .straight:
            shouldAddFirst = false
            shouldAddSecond = false
            lineSpacing = levelSpacing
        case let .straightTop(anchor):
            assert(0...1 ~= anchor)

            shouldAddFirst = true
            shouldAddSecond = false
            lineSpacing = levelSpacing * anchor
        case let .straightBottom(anchor):
            assert(0...1 ~= anchor)

            shouldAddFirst = false
            shouldAddSecond = true
            lineSpacing = levelSpacing * anchor
        }
        graph.nodes.forEach { node in
            let children = graph.getSuccessors(of: node)
            children.forEach { child in
                switch orientation {
                case .topToBottom:
                    move(to: CGPoint(x: child.x + child.width / 2, y: child.y))
                    if shouldAddFirst {
                        addLine(to: CGPoint(x: child.x + child.width / 2, y: child.y - lineSpacing))
                    }
                    if shouldAddSecond {
                        addLine(to: CGPoint(x: node.x + node.width / 2, y: child.y - lineSpacing))
                    }
                    addLine(to: CGPoint(x: node.x + node.width / 2, y: node.y + node.height))
                case .bottomToTop:
                    move(to: CGPoint(x: child.x + child.width / 2, y: child.y + child.height))
                    if shouldAddFirst {
                        addLine(to: CGPoint(x: child.x + child.width / 2, y: child.y + child.height + lineSpacing))
                    }
                    if shouldAddSecond {
                        addLine(to: CGPoint(x: node.x + node.width / 2, y: child.y + child.height + lineSpacing))
                    }
                    addLine(to: CGPoint(x: node.x + node.width / 2, y: node.y + node.height))
                case .leftToRight:
                    move(to: CGPoint(x: child.x, y: child.y + child.height / 2))
                    if shouldAddFirst {
                        addLine(to: CGPoint(x: child.x - lineSpacing, y: child.y + child.height / 2))
                    }
                    if shouldAddSecond {
                        addLine(to: CGPoint(x: child.x - lineSpacing, y: node.y + node.height / 2))
                    }
                    addLine(to: CGPoint(x: node.x + node.width, y: node.y + node.height / 2))
                case .rightToLeft:
                    move(to: CGPoint(x: child.x + child.width, y: child.y + child.height / 2))
                    if shouldAddFirst {
                        addLine(to: CGPoint(x: child.x + child.width + lineSpacing, y: child.y + child.height / 2))
                    }
                    if shouldAddSecond {
                        addLine(to: CGPoint(x: child.x + child.width + lineSpacing, y: node.y + node.height / 2))
                    }
                    addLine(to: CGPoint(x: node.x + node.width, y: node.y + node.height / 2))
                }
            }
        }
    }
}

// TBD
extension UIBezierPath {

    static func parseColored(
        orientation: GraphOrientation,
        spacing: CGFloat,
        graph: Graph,
        lineConfiguration: LinesConfiguration = .rightAngles()
    ) -> [(path: UIBezierPath, color: UIColor)] {
        []
    }
}
