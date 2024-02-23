//
//  BuchheimsWalkerAlgorithm.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 22.02.2024.
//

import Foundation

public class BuchheimsWalkerAlgorithm {
    public let configuration: BuchheimsWalkerConfiguration
    
    var nodeData: [Node: BuchheimsWalkerData] = [:]
    var minNodeHeight: Double = .greatestFiniteMagnitude
    var minNodeWidth: Double = .greatestFiniteMagnitude
    var maxNodeWidth: Double = .greatestFiniteMagnitude
    var maxNodeHeight: Double = .greatestFiniteMagnitude

    var isVertical: Bool { [.topToBottom, .bottomToTop].contains(configuration.orientation) }
    var needReverseOrder: Bool { [.bottomToTop, .rightToLeft].contains(configuration.orientation) }

    public init(configuration: BuchheimsWalkerConfiguration) {
        self.configuration = configuration
    }

    // TODO: - Cycles assertion
    public func run(graph: Graph?, shiftX: Double, shiftY: Double) -> CGSize {
        reset()
        guard let graph else {
            return .zero
        }

        fillData(graph: graph)
        let firstNode = getFirstNode(in: graph)
        firstWalk(graph: graph, node: firstNode, depth: 0, number: 0)
        secondWalk(graph: graph, node: firstNode, modifier: 0.0)
        checkUnconnectedNotes(graph: graph)
        updateNodesPosition(graph: graph)
        shiftCoordinates(graph: graph, shiftX: shiftX, shiftY: shiftY)

        return calculateGraphSize(graph: graph)
    }

    func reset() {
        nodeData.removeAll()
        minNodeHeight = .greatestFiniteMagnitude
        minNodeWidth = .greatestFiniteMagnitude
        maxNodeWidth = .greatestFiniteMagnitude
        maxNodeHeight = .greatestFiniteMagnitude
    }

    func fillData(graph: Graph?) {
        guard let graph else { return }

        graph.nodes.forEach {
            if $0.width.isLessThanOrEqualTo(0) {
                $0.width = configuration.nodeSize.width
            }
            if $0.height.isLessThanOrEqualTo(0) {
                $0.height = configuration.nodeSize.height
            }
        }
        graph.nodes.forEach {
            let data = BuchheimsWalkerData()
            data.ancestor = $0
            nodeData[$0] = data
        }
        graph.edges.forEach {
            nodeData[$0.source]?.successorNodes.append($0.destination)
            nodeData[$0.destination]?.predecessorNodes.append($0.source)
        }
    }

    func getFirstNode(in graph: Graph) -> Node? {
        graph.nodes.first(where: { !hasPredecessor(for: $0) })
    }

    func hasPredecessor(for node: Node?) -> Bool {
        node.flatMap { !getPredecessors(of: $0).isEmpty } ?? false
    }

    func getPredecessors(of node: Node?) -> [Node] {
        node.flatMap { nodeData[$0]?.predecessorNodes } ?? []
    }

    func firstWalk(graph: Graph, node: Node?, depth: Int, number: Int) {
        guard let node, let nodeData = getNodeData(for: node) else { return }

        nodeData.depth = depth
        nodeData.number = number
        minNodeHeight = min(minNodeHeight, node.height)
        maxNodeWidth = max(maxNodeWidth, node.width)
        minNodeWidth = min(minNodeWidth, node.width)
        maxNodeHeight = max(maxNodeHeight, node.height)
        if isLeaf(graph: graph, node: node) {
            if hasLeftNeighbour(graph: graph, node: node) {
                let leftNeighbour = getLeftNeighbour(graph: graph, node: node)
                nodeData.prelim = getPrelim(node: leftNeighbour) + getSpacing(graph: graph, leftNode: leftNeighbour, rightNode: node)
            }
        } else {
            let leftMost = getLeftMostChild(graph: graph, node: node)
            let rightMost = getRightMostChild(graph: graph, node: node)
            var defaultAncestor = leftMost
            var next = leftMost
            var i = 1
            while next != nil {
                i += 1
                firstWalk(graph: graph, node: next, depth: depth + 1, number: i)
                defaultAncestor = apportion(graph: graph, node: next!, defaultAncestor: defaultAncestor!)
                next = getRightNeighbour(graph: graph, node: next)
            }
            executeShifts(graph: graph, node: node)
            let midPoint = 0.5 * ((getPrelim(node: leftMost) + getPrelim(node: rightMost) + ((isVertical ? rightMost?.width : rightMost?.height) ?? 0)) - (isVertical ? node.width : node.height))
            if hasLeftNeighbour(graph: graph, node: node) {
                let leftNeighbour = getLeftNeighbour(graph: graph, node: node)
                nodeData.prelim = getPrelim(node: leftNeighbour) + getSpacing(graph: graph, leftNode: leftNeighbour, rightNode: node)
                nodeData.modifier = nodeData.prelim - midPoint
            } else {
                nodeData.prelim = midPoint
            }
        }
    }

    func getNodeData(for node: Node?) -> BuchheimsWalkerData? {
        node.flatMap { nodeData[$0] }
    }

    func isLeaf(graph: Graph, node: Node) -> Bool {
        getSuccessors(of: node).isEmpty
    }

    func getSuccessors(of node: Node?) -> [Node] {
        node.flatMap { nodeData[$0]?.successorNodes } ?? []
    }

    func hasLeftNeighbour(graph: Graph, node: Node?) -> Bool {
        guard let node else {
            return false
        }

        let parents = getPredecessors(of: node)
        if parents.isEmpty {
            return false
        } else {
            return getSuccessors(of: parents.first).firstIndex(of: node).flatMap { $0 > 0 } ?? false
        }
    }

    func getLeftNeighbour(graph: Graph, node: Node?) -> Node? {
        guard let node else {
            return nil
        }

        if !hasLeftNeighbour(graph: graph, node: node) {
            return nil
        } else {
            let children = getSuccessors(of: getPredecessors(of: node).first)
            guard let index = children.firstIndex(of: node), index > 0 else {
                return nil
            }

            return children[index - 1]
        }
    }

    func getPrelim(node: Node?) -> Double {
        getNodeData(for: node)?.prelim ?? 0
    }

    func getSpacing(graph: Graph, leftNode: Node?, rightNode: Node) -> Double {
        let spacing: CGFloat
        if isNeighbour(graph: graph, leftNode: leftNode, rightNode: rightNode) {
            spacing = CGFloat(configuration.neighbourSpacing)
        } else {
            spacing = CGFloat(configuration.subtreeSpacing)
        }
        let length = (isVertical ? leftNode?.width : leftNode?.height) ?? 0

        return spacing + length
    }

    func getLeftMostChild(graph: Graph, node: Node?) -> Node? {
        getSuccessors(of: node).first
    }

    func getRightMostChild(graph: Graph, node: Node?) -> Node? {
        getSuccessors(of: node).last
    }

    func apportion(graph: Graph, node: Node, defaultAncestor: Node) -> Node {
        var ancestor = defaultAncestor
        if hasLeftNeighbour(graph: graph, node: node) {
            let leftNeighbour = getLeftNeighbour(graph: graph, node: node)
            var vop: Node? = node
            var vom = getLeftMostChild(graph: graph, node: graph.getPredecessors(of: node).first)
            var sip = getModifier(node: node)
            var sop = getModifier(node: node)
            var sim = getModifier(node: leftNeighbour)
            var som = getModifier(node: vom)
            var nextRight = self.nextRight(graph: graph, node: leftNeighbour)
            var nextLeft = self.nextLeft(graph: graph, node: node)
            while nextRight != nil && nextLeft != nil {
                vom = self.nextLeft(graph: graph, node: vom)
                vop = self.nextRight(graph: graph, node: vop)
                setAncestor(node: vop, ancestor: node)
                let shift = getPrelim(node: nextRight) + sim - (getPrelim(node: nextLeft) + sip) + getSpacing(graph: graph, leftNode: nextRight, rightNode: node)
                if shift > 0 {
                    moveSubtree(ancestor: self.ancestor(graph: graph, next: nextRight, node: node, defaultAncestor: ancestor), next: node, shift: shift)
                    sip += shift
                    sop += shift
                }
                sim += getModifier(node: nextRight)
                sip += getModifier(node: nextLeft)
                som += getModifier(node: vom)
                sop += getModifier(node: vop)
                nextRight = self.nextRight(graph: graph, node: nextRight)
                nextLeft = self.nextLeft(graph: graph, node: nextLeft)
            }
            if nextRight != nil && self.nextRight(graph: graph, node: vop) == nil {
                setThread(node: vop, thread: nextRight)
                setModifier(node: vop, modifier: getModifier(node: vop) + sim - sop)
            }
            if nextLeft != nil && self.nextLeft(graph: graph, node: vom) == nil {
                setThread(node: vom, thread: nextLeft)
                setModifier(node: vom, modifier: getModifier(node: vom) + sip - som)
                ancestor = node
            }
        }

        return ancestor
    }

    func executeShifts(graph: Graph, node: Node) {
        var shift = 0.0
        var change = 0.0
        var shiftNode = getRightMostChild(graph: graph, node: node)
        while shiftNode != nil {
            var data: BuchheimsWalkerData
            if let nodeData = getNodeData(for: shiftNode) {
                data = nodeData
            } else {
                data = .init()
                nodeData[shiftNode!] = data
            }
            data.prelim = data.prelim + shift
            data.modifier = data.modifier + shift
            change += data.change
            shift += data.shift + change
            shiftNode = getLeftNeighbour(graph: graph, node: shiftNode)
        }
    }

    func getModifier(node: Node?) -> Double {
        getNodeData(for: node)?.modifier ?? 0
    }

    func setAncestor(node: Node?, ancestor: Node?) {
        getNodeData(for: node)?.ancestor = ancestor
    }

    func secondWalk(graph: Graph, node: Node?, modifier: Double) {
        guard let node else { return }

        let nodeData = getNodeData(for: node)
        let depth = Double(nodeData?.depth ?? 0)
        let vertical = isVertical
        node.origin = CGPoint(
            x: (nodeData?.prelim ?? 0) + modifier,
            y: depth * (vertical ? minNodeHeight : minNodeWidth) + (depth * configuration.levelSpacing).rounded(.up)
        )
        graph.getSuccessors(of: node).forEach { successor in
            secondWalk(graph: graph, node: successor, modifier: modifier + (nodeData?.modifier ?? 0))
        }
    }

    func calculateGraphSize(graph: Graph) -> CGSize {
        var left: Double = .greatestFiniteMagnitude
        var top: Double = .greatestFiniteMagnitude
        var right: Double = -.greatestFiniteMagnitude
        var bottom: Double = -.greatestFiniteMagnitude
        graph.nodes.forEach { node in
            left = min(left, node.x)
            top = min(top, node.y)
            right = max(right, node.x + node.width)
            bottom = max(bottom, node.y + node.height)
        }

        return CGSize(width: max(0, right - left), height: max(0, bottom - top))
    }

    func checkUnconnectedNotes(graph: Graph) {
        #if DEBUG
        graph.nodes.forEach { element in
            if getNodeData(for: element) == nil {
                print("\nNot connected node:")
                dump(element)
                print()
            }
        }
        #endif
    }

    func setModifier(node: Node?, modifier: Double) {
        getNodeData(for: node)?.modifier = modifier
    }

    func setThread(node: Node?, thread: Node?) {
        getNodeData(for: node)?.thread = thread
    }

    func moveSubtree(ancestor: Node?, next: Node?, shift: Double) {
        guard let nextNodeData = getNodeData(for: next), let ancestorNodeData = getNodeData(for: ancestor) else { return }

        let subtrees = Double(nextNodeData.number - ancestorNodeData.number)
        nextNodeData.change = (nextNodeData.change - shift / subtrees)
        nextNodeData.shift = (nextNodeData.shift + shift)
        ancestorNodeData.change = (ancestorNodeData.change + shift / subtrees)
        nextNodeData.prelim = (nextNodeData.prelim + shift)
        nextNodeData.modifier = (nextNodeData.modifier + shift)
    }

    func ancestor(graph: Graph, next: Node?, node: Node, defaultAncestor: Node) -> Node? {
        guard let nextNodeData = getNodeData(for: next) else {
            return defaultAncestor
        }

        return getPredecessors(of: nextNodeData.ancestor).first == getPredecessors(of: node).first
        ? nextNodeData.ancestor
        : defaultAncestor
    }

    func nextRight(graph: Graph, node: Node?) -> Node? {
        graph.hasSuccessor(for: node) ?
        getRightMostChild(graph: graph, node: node) :
        getNodeData(for: node)?.thread
    }

    func nextLeft(graph: Graph, node: Node?) -> Node? {
        hasSuccessor(node: node)
        ? getLeftMostChild(graph: graph, node: node)
        : getNodeData(for: node)?.thread
    }

    func isNeighbour(graph: Graph, leftNode: Node?, rightNode: Node) -> Bool {
        getSuccessors(of: getPredecessors(of: leftNode).first).contains(rightNode)
    }

    func getRightNeighbour(graph: Graph, node: Node?) -> Node? {
        guard let node else {
            return nil
        }

        if !hasRightNeighbour(graph: graph, node: node) {
            return nil
        } else {
            let children = getSuccessors(of: getPredecessors(of: node).first)
            guard let index = children.firstIndex(of: node) else {
                return nil
            }

            return children[index + 1]
        }
    }

    func hasRightNeighbour(graph: Graph, node: Node?) -> Bool {
        guard let node else {
            return false
        }

        let parents = getPredecessors(of: node)
        if parents.isEmpty {
            return false
        } else {
            let children = getSuccessors(of: parents.first)
            guard let index = children.firstIndex(of: node) else {
                return false
            }

            return index < children.count - 1
        }
    }

    func updateNodesPosition(graph: Graph) {
        let doesNeedReverseOrder = needReverseOrder
        let offset = getOffset(graph: graph, needReverseOrder: doesNeedReverseOrder)
        let nodes = sortByLevel(graph: graph, descending: doesNeedReverseOrder)
        let firstLevel = getNodeData(for: nodes.first)?.depth ?? 0
        var localMaxSize = findMaxSize(nodes: filterByLevel(nodes: nodes, level: firstLevel))
        var currentLevel = doesNeedReverseOrder ? firstLevel : 0
        var globalPadding = 0.0
        var localPadding = 0.0
        nodes.forEach { node in
            let depth = getNodeData(for: node)?.depth ?? 0
            if depth != currentLevel {
                if doesNeedReverseOrder {
                    globalPadding -= localPadding
                } else {
                    globalPadding += localPadding
                }
                localPadding = 0.0
                currentLevel = depth
                localMaxSize = findMaxSize(nodes: filterByLevel(nodes: nodes, level: currentLevel))
            }
            let height = node.height
            let width = node.width
            switch configuration.orientation {
            case .topToBottom:
                if height > minNodeHeight {
                    let diff = height - minNodeHeight
                    localPadding = max(localPadding, diff)
                }
            case .bottomToTop:
                if height < localMaxSize.height {
                    let diff = localMaxSize.height - height
                    node.origin.y -= diff
                    localPadding = max(localPadding, diff)
                }
            case .leftToRight:
                if width > minNodeWidth {
                    let diff = width - minNodeWidth
                    localPadding = max(localPadding, diff)
                }
            case .rightToLeft:
                if width < localMaxSize.width {
                    let diff = localMaxSize.width - width
                    node.origin.y -= diff
                    localPadding = max(localPadding, diff)
                }
            }
            node.origin = getPosition(node: node, globalPadding: globalPadding, offset: offset);
        }
    }

    func shiftCoordinates(graph: Graph, shiftX: Double, shiftY: Double) {
        graph.nodes.forEach { node in
            node.origin = CGPoint(x: node.x + shiftX, y: node.y + shiftY)
        }
    }

    func findMaxSize(nodes: [Node]) -> CGSize {
        var width: Double = -.greatestFiniteMagnitude
        var height: Double = -.greatestFiniteMagnitude
        nodes.forEach { node in
            width = max(width, node.width)
            height = max(height, node.height)
        }

        return CGSize(width: width, height: height)
    }

    func getOffset(graph: Graph, needReverseOrder: Bool) -> CGPoint {
        var offsetX: Double = .greatestFiniteMagnitude
        var offsetY: Double = .greatestFiniteMagnitude
        if needReverseOrder {
            offsetY = .leastNormalMagnitude
        }
        graph.nodes.forEach { node in
            if needReverseOrder {
                offsetX = min(offsetX, node.x)
                offsetY = max(offsetY, node.y)
            } else {
                offsetX = min(offsetX, node.x)
                offsetY = min(offsetY, node.y)
            }
        }

        return CGPoint(x: offsetX, y: offsetY)
    }

    func getPosition(node: Node, globalPadding: Double, offset: CGPoint) -> CGPoint {
        switch configuration.orientation {
        case .topToBottom: CGPoint(x: node.x - offset.x, y: node.y + globalPadding)
        case .bottomToTop: CGPoint(x: node.x - offset.x, y: offset.y - node.y - globalPadding)
        case .leftToRight: CGPoint(x: node.y + globalPadding, y: node.x - offset.x)
        case .rightToLeft: CGPoint(x: offset.y - node.y - globalPadding, y: node.x - offset.x)
        }
    }

    func sortByLevel(graph: Graph, descending: Bool) -> [Node] {
        var nodes = descending ? graph.nodes.reversed() : graph.nodes
        nodes.sort(by: { (getNodeData(for: $0)?.depth ?? 0) <= (getNodeData(for: $1)?.depth ?? 1) })

        return nodes
    }

    func filterByLevel(nodes: [Node], level: Int?) -> [Node] {
        nodes.filter { getNodeData(for: $0)?.depth == level }
    }

    func hasSuccessor(node: Node?) -> Bool {
        node.flatMap { !getSuccessors(of: $0).isEmpty } ?? false
    }

    func step(graph: Graph?) {
        guard let graph else { return }

        let firstNode = getFirstNode(in: graph)
        firstWalk(graph: graph, node: firstNode, depth: 0, number: 0)
        secondWalk(graph: graph, node: firstNode, modifier: 0.0)
        checkUnconnectedNotes(graph: graph)
        updateNodesPosition(graph: graph)
    }
}
