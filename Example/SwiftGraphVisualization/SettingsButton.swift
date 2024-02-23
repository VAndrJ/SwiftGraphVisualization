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

    convenience init(kind: Kind, onTap: @escaping () -> Void) {
        self.init(icon: kind.rawValue, onTap: onTap)
    }

    convenience init(icon: String, onTap: @escaping () -> Void) {
        self.init(type: .system)

        self.onTap = onTap
        setImage(UIImage(systemName: icon), for: .normal)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 64).apply { $0.priority = .init(999) },
            heightAnchor.constraint(equalToConstant: 64).apply { $0.priority = .init(999) },
        ])
        addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    }

    @objc private func onButtonTap() {
        onTap?()
    }
}
