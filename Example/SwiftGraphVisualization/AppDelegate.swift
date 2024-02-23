//
//  AppDelegate.swift
//  SwiftGraphVisualization
//
//  Created by VAndrJ on 02/22/2024.
//  Copyright (c) 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        window?.rootViewController = ViewController(view: ExampleScreenView())
        window?.makeKeyAndVisible()
        
        return true
    }
}
