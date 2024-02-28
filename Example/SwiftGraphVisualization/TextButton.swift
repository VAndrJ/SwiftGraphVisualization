//
//  TextButton.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 26.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class TextButton: UIButton {
    private var onTap: (() -> Void)?

    convenience init(
        title: String,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        onTap: @escaping () -> Void
    ) {
        self.init(type: .system)

        self.onTap = onTap
        setTitle(title, for: .normal)
        if let height {
            heightAnchor.constraint(equalToConstant: height).apply { $0.priority = .init(999) }.isActive = true
        }
        if let width {
            widthAnchor.constraint(equalToConstant: width).apply { $0.priority = .init(999) }.isActive = true
        }
        addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    }

    @objc private func onButtonTap() {
        onTap?()
    }
}
