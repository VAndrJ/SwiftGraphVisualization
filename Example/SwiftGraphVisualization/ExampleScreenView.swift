//
//  ExampleScreenView.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 22.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit
import SwiftGraphVisualization

class ExampleScreenView: ControllerView {
    private let graph = Graph()
    private lazy var graphCanvasView = GraphCanvasView(
        graph: graph,
        algorithm: BuchheimsWalkerAlgorithm(configuration: .init()),
        linesColor: .systemBlue,
        linesConfiguration: .rightAngles(anchor: 0.4),
        pathConfigurationBlock: { path in
            path.lineWidth = 4
            path.lineJoinStyle = .round
            path.lineCapStyle = .round
        },
        nodeViewBuilder: { [weak self] node in
            switch node {
            case let node as NumberNode:
                NumberNodeView(node: node) { [weak self] in
                    self?.addNode(source: node)
                }
            default:
                NodeView(node: node) { [weak self] in
                    self?.remove(node: node)
                }
            }
        }
    )
    private lazy var orientationTopToBottomButton = SettingsButton(kind: .topToBottom) { [weak self] in
        self?.updateOrientation(to: .topToBottom)
    }
    private lazy var orientationBottomToTopButton = SettingsButton(kind: .bottomToTop) { [weak self] in
        self?.updateOrientation(to: .bottomToTop)
    }
    private lazy var orientationLeftToRightButton = SettingsButton(kind: .leftToRight) { [weak self] in
        self?.updateOrientation(to: .leftToRight)
    }
    private lazy var orientationRightToLeftButton = SettingsButton(kind: .rightToLeft) { [weak self] in
        self?.updateOrientation(to: .rightToLeft)
    }
    private lazy var spacingHorizontalIncreaseButton = SettingsButton(kind: .horizontalIncrease) { [weak self] in
        self?.changeSpacing(.horizontal(.increase))
    }
    private lazy var spacingVerticalIncreaseButton = SettingsButton(kind: .verticalIncrease) { [weak self] in
        self?.changeSpacing(.vertical(.increase))
    }
    private lazy var spacingHorizontalDecreaseButton = SettingsButton(kind: .horizontalDecrease) { [weak self] in
        self?.changeSpacing(.horizontal(.decrease))
    }
    private lazy var spacingVerticalDecreaseButton = SettingsButton(kind: .verticalDecrease) { [weak self] in
        self?.changeSpacing(.vertical(.decrease))
    }
    // TBD
    private let presentSwiftUIExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SwiftUI Example", for: .normal)

        return button
    }()

    override init() {

        super.init()

        addElements()
        prefillGraph()
        updateSettingsIndication()
    }

    private func addElements() {
        addAutolayoutSubview(
            ColumnStackView(children: [
                RowStackView(children: [
                    orientationTopToBottomButton,
                    orientationBottomToTopButton,
                    orientationLeftToRightButton,
                    orientationRightToLeftButton,
                ]),
                RowStackView(children: [
                    spacingVerticalIncreaseButton,
                    spacingVerticalDecreaseButton,
                    spacingHorizontalIncreaseButton,
                    spacingHorizontalDecreaseButton,
                ]),
                graphCanvasView,
            ]),
            constraints: {
                $0.topAnchor.equal(to: safeAreaLayoutGuide.topAnchor)
                $0.leftAnchor.equal(to: safeAreaLayoutGuide.leftAnchor)
                $0.rightAnchor.equal(to: safeAreaLayoutGuide.rightAnchor)
                $0.bottomAnchor.equal(to: safeAreaLayoutGuide.bottomAnchor)
            }
        )
    }

    // MARK: - Graph

    private func prefillGraph() {
        let node1 = NumberNode(number: 1)
        graph.addEdge(source: node1, destination: NumberNode(number: 2))
        graph.addEdge(source: node1, destination: Node())
    }

    private func addNode(source node: NumberNode) {
        graph.addEdge(
            source: node,
            destination: Int.random(in: 0...3) == 0 ? Node() : NumberNode(number: node.number + 1)
        )
    }

    // TODO: -
    private func remove(node: Node) {
        dump(node)
    }

    // MARK: - Settings

    private enum SpacingChange {
        enum Operation {
            case increase
            case decrease
        }

        case horizontal(Operation)
        case vertical(Operation)
    }

    private func changeSpacing(_ change: SpacingChange) {
        switch change {
        case let .horizontal(operation):
            switch operation {
            case .increase:
                graphCanvasView.configuration.neighbourSpacing += 5
            case .decrease:
                graphCanvasView.configuration.neighbourSpacing = max(0, graphCanvasView.configuration.neighbourSpacing - 5)
            }
        case let .vertical(operation):
            switch operation {
            case .increase:
                graphCanvasView.configuration.levelSpacing += 5
            case .decrease:
                graphCanvasView.configuration.levelSpacing = max(5, graphCanvasView.configuration.levelSpacing - 5)
            }
        }
        graphCanvasView.update()
    }

    private func updateOrientation(to newOrientation: GraphOrientation) {
        guard graphCanvasView.configuration.orientation != newOrientation else { return }

        graphCanvasView.configuration.orientation = newOrientation
        graphCanvasView.update()
        updateSettingsIndication()
    }

    private func updateSettingsIndication() {
        orientationTopToBottomButton.tintColor = graphCanvasView.configuration.orientation == .topToBottom ? .systemGreen : .systemBlue
        orientationBottomToTopButton.tintColor = graphCanvasView.configuration.orientation == .bottomToTop ? .systemGreen : .systemBlue
        orientationLeftToRightButton.tintColor = graphCanvasView.configuration.orientation == .leftToRight ? .systemGreen : .systemBlue
        orientationRightToLeftButton.tintColor = graphCanvasView.configuration.orientation == .rightToLeft ? .systemGreen : .systemBlue
    }
}
