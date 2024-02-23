//
//  ViewController.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 02/22/2024.
//  Copyright (c) 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

class ControllerView: VAView {
    weak var controller: UIViewController?

    func viewDidAppear(_ animated: Bool) {}
}

class VAView: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController<View: ControllerView>: UIViewController {
    let contentView: View

    init(view: View) {
        self.contentView = view

        super.init(nibName: nil, bundle: nil)

        contentView.controller = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentView.viewDidAppear(animated)
    }
}
