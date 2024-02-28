//
//  GraphCanvasView.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 23.02.2024.
//

import UIKit

open class GraphCanvasView: UIScrollView, UIScrollViewDelegate {
    public var configuration: BuchheimsWalkerConfiguration { algorithm.configuration }
    public let graph: Graph
    public let graphView: GraphDrawingView
    public let algorithm: BuchheimsWalkerAlgorithm
    public var pathConfigurationBlock: ((UIBezierPath) -> Void)? {
        didSet { updateGraphPath() }
    }
    public var linesConfiguration: LinesConfiguration {
        didSet { updateGraphPath() }
    }
    public private(set) var nodesDict: [Node: UIView] = [:]

    var cHeight: NSLayoutConstraint?
    var cWidth: NSLayoutConstraint?
    let nodeViewBuilder: (Node) -> UIView
    let shift: CGSize

    public init(
        graph: Graph,
        algorithm: BuchheimsWalkerAlgorithm,
        linesColor: UIColor,
        linesConfiguration: LinesConfiguration,
        contentInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16),
        shift: CGSize = .zero,
        pathConfigurationBlock: ((UIBezierPath) -> Void)? = nil,
        nodeViewBuilder: @escaping (Node) -> UIView
    ) {
        self.nodeViewBuilder = nodeViewBuilder
        self.algorithm = algorithm
        self.graph = graph
        self.graphView = GraphDrawingView(color: linesColor)
        self.shift = shift
        self.pathConfigurationBlock = pathConfigurationBlock
        self.linesConfiguration = linesConfiguration

        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 667))

        self.contentInset = contentInset
        addElements()
        configure()
        bind()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func update() {
        runAlgorithm()
        updateGraphPath()
        updateGraphViews()
    }

    open func runAlgorithm() {
        let size = algorithm.run(
            graph: graph,
            shiftX: shift.width,
            shiftY: shift.height
        )
        cHeight?.constant = size.height
        cWidth?.constant = size.width
    }

    open func updateGraphPath() {
        let path = UIBezierPath(
            configuration: algorithm.configuration,
            graph: graph,
            linesConfiguration: linesConfiguration
        )
        pathConfigurationBlock?(path)
        graphView.path = path
    }

    open func updateGraphViews() {
        let existingNodes = Set(nodesDict.keys)
        let newNodes = Set(graph.nodes)
        let nodesToRemove = existingNodes.subtracting(newNodes)
        let nodesToAdd = newNodes.subtracting(existingNodes)
        let nodesToUpdate = existingNodes.intersection(newNodes)
        nodesToRemove.forEach {
            nodesDict.removeValue(forKey: $0)?.removeFromSuperview()
        }
        nodesToUpdate.forEach {
            nodesDict[$0]?.frame = .init(origin: $0.origin, size: $0.size)
        }
        nodesToAdd.forEach {
            let nodeView = nodeViewBuilder($0)
            nodesDict[$0] = nodeView
            graphView.addSubview(nodeView)
        }
        layoutIfNeeded()
    }

    open func bind() {
        delegate = self
        graph.add(didChangedBlock: { [weak self] in
            self?.update()
        })
    }

    open func configure() {
        minimumZoomScale = 0.1
        maximumZoomScale = 3
        alwaysBounceVertical = true
        alwaysBounceHorizontal = true
        contentInsetAdjustmentBehavior = .never
    }

    open func addElements() {
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

    // MARK: - UIScrollViewDelegate

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        graphView
    }
}
