//
//  GraphCanvasView.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 23.02.2024.
//

import UIKit

public class GraphCanvasView: UIScrollView, UIScrollViewDelegate {
    public var configuration: BuchheimsWalkerConfiguration { algorithm.configuration }
    public let graph: Graph
    public let graphView: GraphDrawingView
    public let algorithm: BuchheimsWalkerAlgorithm

    var cHeight: NSLayoutConstraint?
    var cWidth: NSLayoutConstraint?
    let nodeViewBuilder: (Node) -> UIView
    let shift: CGSize

    public init(
        graph: Graph,
        algorithm: BuchheimsWalkerAlgorithm,
        linesColor: UIColor,
        contentInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16),
        minimumZoomScale: CGFloat = 0.1,
        maximumZoomScale: CGFloat = 3,
        shift: CGSize = .zero,
        nodeViewBuilder: @escaping (Node) -> UIView
    ) {
        self.nodeViewBuilder = nodeViewBuilder
        self.algorithm = algorithm
        self.graph = graph
        self.graphView = GraphDrawingView(color: linesColor)
        self.shift = shift

        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 667))

        // TODO: - Dynamic on graph changes
        self.minimumZoomScale = minimumZoomScale
        self.maximumZoomScale = maximumZoomScale
        self.contentInset = contentInset
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
        contentInsetAdjustmentBehavior = .never
        delegate = self
        addElements()
        graph.add(didChangedBlock: { [weak self] in 
            self?.update()
        })
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update() {
        let size = algorithm.run(
            graph: graph,
            shiftX: shift.width,
            shiftY: shift.height
        )
        cHeight?.constant = size.height
        cWidth?.constant = size.width
        graphView.path = UIBezierPath(
            configuration: algorithm.configuration,
            graph: graph
        )
        // TODO: - Diff & update existing
        graphView.nodesViews = graph.nodes.map { nodeViewBuilder($0) }
        layoutIfNeeded()
    }

    private func addElements() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(graphView)
        let cHeight = graphView.heightAnchor.constraint(equalToConstant: 0)
        let cWidth = graphView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: topAnchor),
            graphView.leftAnchor.constraint(equalTo: leftAnchor),
            graphView.rightAnchor.constraint(equalTo: rightAnchor),
            graphView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cHeight,
            cWidth,
        ])
        self.cHeight = cHeight
        self.cWidth = cWidth
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        graphView
    }
}
