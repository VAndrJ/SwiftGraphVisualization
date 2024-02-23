//
//  RowStackView.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 23.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class RowStackView: UIStackView {

    init(children: [UIView]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 100))

        alignment = .center
        axis = .horizontal
        distribution = .fillEqually
        children.forEach(addArrangedSubview(_:))
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
