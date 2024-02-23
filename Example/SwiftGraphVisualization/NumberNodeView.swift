//
//  NumberNodeView.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 23.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class NumberNodeView: VAView {
    let nodeId: UUID
    let label: UILabel
    let onTap: () -> Void

    init(node: NumberNode, onTap: @escaping () -> Void) {
        self.nodeId = node.id
        self.label = UILabel()
        self.onTap = onTap

        super.init(frame: .init(origin: node.origin, size: node.size))

        label.text = "\(node.number)"
        label.sizeToFit()
        backgroundColor = .white
        addSubview(label)
        label.textColor = .black
        isUserInteractionEnabled = true
        bind()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.center = .init(x: bounds.midX, y: bounds.midY)
    }

    @objc private func onViewTap(_ sender: UITapGestureRecognizer) {
        guard sender.state == .recognized else { return }

        onTap()
    }

    private func bind() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTap(_:))))
    }
}
