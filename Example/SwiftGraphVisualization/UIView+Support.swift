//
//  UIView+Support.swift
//  SwiftGraphVisualization_Example
//
//  Created by VAndrJ on 22.02.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

extension UIView {

    func addAutolayoutSubview(
        _ view: UIView,
        @ConstraintsBuilder constraints: (UIView) -> [NSLayoutConstraint]
    ) {
        addAutolayoutSubview(view)
        NSLayoutConstraint.activate(constraints(view))
    }

    func addAutolayoutSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    func addAutolayoutSubviews(_ views: UIView...) {
        views.forEach(addAutolayoutSubview(_:))
    }
}

extension NSLayoutAnchor {

    @objc func equal(to anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint {
        constraint(equalTo: anchor)
    }
}

@resultBuilder
public struct ConstraintsBuilder {

    public static func buildBlock(_ components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        components
    }

    public static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [expression]
    }

    public static func buildExpression(_ expression: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        expression
    }

    public static func buildOptional(_ component: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
        component ?? []
    }

    public static func buildEither(first component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        component
    }

    public static func buildEither(second component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        component
    }
}
