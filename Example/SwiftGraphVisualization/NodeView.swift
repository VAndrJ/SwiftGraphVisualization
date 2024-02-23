//
//  NodeView.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 23.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit
import SwiftGraphVisualization

class NodeView: VAView {
    let nodeId: UUID
    let onTap: () -> Void

    init(node: Node, onTap: @escaping () -> Void) {
        self.nodeId = node.id
        self.onTap = onTap

        super.init(frame: .init(origin: node.origin, size: node.size))

        backgroundColor = .systemGray
        isUserInteractionEnabled = true
        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    @objc private func onViewTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .recognized else { return }

        onTap()
    }

    private func bind() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap(_:))))
    }
}
