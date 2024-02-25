//
//  UIBezierPath+GraphSupport.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 23.02.2024.
//

import UIKit

// TBD
public enum LinesConfiguration {
    case rightAngles
}

public extension UIBezierPath {

    convenience init(
        configuration: BuchheimsWalkerConfiguration,
        graph: Graph,
        linesConfiguration: LinesConfiguration = .rightAngles
    ) {
        self.init()

        self.init(
            orientation: configuration.orientation,
            spacing: configuration.levelSpacing,
            graph: graph,
            linesConfiguration: linesConfiguration
        )
    }

    convenience init(
        orientation: GraphOrientation,
        spacing: CGFloat,
        graph: Graph,
        linesConfiguration: LinesConfiguration = .rightAngles
    ) {
        self.init()

        let spacing = spacing / 2
        graph.nodes.forEach { node in
            let children = graph.getSuccessors(of: node)
            children.forEach { child in
                switch orientation {
                case .topToBottom:
                    move(to: CGPoint(x: child.x + child.width / 2, y: child.y))
                    addLine(to: CGPoint(x: child.x + child.width / 2, y: child.y - spacing))
                    addLine(to: CGPoint(x: node.x + node.width / 2, y: child.y - spacing))
                    addLine(to: CGPoint(x: node.x + node.width / 2, y: node.y + node.height))
                case .bottomToTop:
                    move(to: CGPoint(x: child.x + child.width / 2, y: child.y + child.height))
                    addLine(to: CGPoint(x: child.x + child.width / 2, y: child.y + child.height + spacing))
                    addLine(to: CGPoint(x: node.x + node.width / 2, y: child.y + child.height + spacing))
                    addLine(to: CGPoint(x: node.x + node.width / 2, y: node.y + node.height))
                case .leftToRight:
                    move(to: CGPoint(x: child.x, y: child.y + child.height / 2))
                    addLine(to: CGPoint(x: child.x - spacing, y: child.y + child.height / 2))
                    addLine(to: CGPoint(x: child.x - spacing, y: node.y + node.height / 2))
                    addLine(to: CGPoint(x: node.x + node.width, y: node.y + node.height / 2))
                case .rightToLeft:
                    move(to: CGPoint(x: child.x + child.width, y: child.y + child.height / 2))
                    addLine(to: CGPoint(x: child.x + child.width + spacing, y: child.y + child.height / 2))
                    addLine(to: CGPoint(x: child.x + child.width + spacing, y: node.y + node.height / 2))
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
        lineConfiguration: LinesConfiguration = .rightAngles
    ) -> [(path: UIBezierPath, color: UIColor)] {
        []
    }
}
