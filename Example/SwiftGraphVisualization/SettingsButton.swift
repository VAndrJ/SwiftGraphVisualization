//
//  SettingsButton.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 23.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class SettingsButton: UIButton {
    enum Kind: String {
        case topToBottom = "arrow.down"
        case bottomToTop = "arrow.up"
        case leftToRight = "arrow.right"
        case rightToLeft = "arrow.left"
        case horizontalIncrease = "arrow.left.and.line.vertical.and.arrow.right"
        case horizontalDecrease = "arrow.right.and.line.vertical.and.arrow.left"
        case verticalIncrease = "arrow.up.and.line.horizontal.and.arrow.down"
        case verticalDecrease = "arrow.down.and.line.horizontal.and.arrow.up"
    }

    var onTap: (() -> Void)?

    convenience init(
        kind: Kind,
        width: CGFloat? = 64,
        height: CGFloat? = 64,
        onTap: @escaping () -> Void
    ) {
        self.init(
            icon: kind.rawValue,
            width: width,
            height: height,
            onTap: onTap
        )
    }

    convenience init(
        icon: String,
        width: CGFloat? = 64,
        height: CGFloat? = 64,
        onTap: @escaping () -> Void
    ) {
        self.init(type: .system)

        self.onTap = onTap
        setImage(UIImage(systemName: icon), for: .normal)
        if let width {
            widthAnchor.constraint(equalToConstant: width).apply { $0.priority = .init(999) }.isActive = true
        }
        if let height {
            heightAnchor.constraint(equalToConstant: height).apply { $0.priority = .init(999) }.isActive = true
        }
        addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    }

    @objc private func onButtonTap() {
        onTap?()
    }
}
