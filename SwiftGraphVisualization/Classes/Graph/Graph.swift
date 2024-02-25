//
//  Graph.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 22.02.2024.
//

import Foundation

public class Graph {
    public var count: Int { _nodes.count }
    public var nodes: [Node] { _nodes }
    public var edges: [Edge] { _edges }
    public var isEmpty: Bool { _nodes.isEmpty }

    var _nodes: [Node] = []
    var _edges: [Edge] = []
    var graphDelegates: [() -> GraphDelegate?] = []
    var graphDidChangedBlocks: [() -> Void] = []
    var isTree: Bool

    public init(isTree: Bool = true) {
        self.isTree = isTree
    }

    public func add(node: Node) {
        _nodes.append(node)
        graphDidChanged()
    }

    public func remove(node: Node?) {
        guard let node else { return }

        if isTree {
            getSuccessors(of: node).forEach(remove(node:))
        }
        _nodes.removeAll(where: { $0 == node })
        _edges.removeAll(where: { $0.source == node || $0.destination == node })
        graphDidChanged()
    }

    @discardableResult
    public func addEdge(source: Node, destination: Node) -> Edge {
        let edge = Edge(source: source, destination: destination)
        add(edge: edge)

        return edge
    }

    func add(edge: Edge) {
        var sourceSet = false
        var destinationSet = false
        _nodes.forEach { node in
            if !sourceSet && node == edge.source {
                edge.source = node
                sourceSet = true
            } else if !destinationSet && node == edge.destination {
                edge.destination = node
                destinationSet = true
            }
        }
        if !sourceSet {
            _nodes.append(edge.source)
        }
        if !destinationSet {
            _nodes.append(edge.destination)
        }
        if !_edges.contains(edge) {
            _edges.append(edge)
            graphDidChanged()
        }
    }

    public func remove(edge: Edge) {
        _edges.removeAll(where: { $0 == edge })
        graphDidChanged()
    }

    public func getEdgeBetween(source: Node, destination: Node?) -> Edge? {
        destination.flatMap { destination in
            _edges.first(where: { $0.source == source && $0.destination == destination })
        }
    }

    public func getNodeBy(id: UUID) -> Node? {
        _nodes.first(where: { $0.id == id })
    }

    public func hasSuccessor(for node: Node?) -> Bool {
        node.flatMap { node in _edges.contains(where: { $0.source == node }) } ?? false
    }

    public func getSuccessors(of node: Node?) -> [Node] {
        getOutgoingEdges(of: node).map(\.destination)
    }

    public func hasPredecessor(for node: Node?) -> Bool {
        node.flatMap { node in _edges.contains(where: { $0.destination == node }) } ?? false
    }

    public func getPredecessors(of node: Node?) -> [Node] {
        getIncomingEdges(of: node).map(\.source)
    }

    public func getOutgoingEdges(of node: Node?) -> [Edge] {
        node.flatMap { node in _edges.filter { $0.source == node } } ?? []
    }

    public func getIncomingEdges(of node: Node?) -> [Edge] {
        node.flatMap { node in _edges.filter { $0.destination == node } } ?? []
    }

    public func add(delegate: GraphDelegate?) {
        graphDelegates.append({ [weak delegate] in delegate })
        delegate?.graphDidChanged()
    }

    public func add(didChangedBlock: @escaping () -> Void) {
        graphDidChangedBlocks.append(didChangedBlock)
        didChangedBlock()
    }

    func graphDidChanged() {
        graphDelegates.forEach { $0()?.graphDidChanged() }
        graphDidChangedBlocks.forEach { $0() }
    }
}
