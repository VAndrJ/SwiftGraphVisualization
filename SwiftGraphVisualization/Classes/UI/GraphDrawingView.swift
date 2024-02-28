//
//  GraphDrawingView.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 23.02.2024.
//

import UIKit

open class GraphDrawingView: UIView {
    public var path: UIBezierPath? {
        didSet { setNeedsDisplay() }
    }
    public var color: UIColor {
        didSet { setNeedsDisplay() }
    }

    public init(color: UIColor) {
        self.color = color

        super.init(frame: .zero)

        backgroundColor = .clear
        isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func draw(_ rect: CGRect) {
        color.setStroke()
        path?.stroke()
    }
}
