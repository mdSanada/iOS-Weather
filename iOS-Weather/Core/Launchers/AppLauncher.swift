//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//
import UIKit
import SnapKit

final class AppLauncher: Launcher {
    
    var window: UIWindow?
    private var child: Coordinator?
    
    private var viewController: UIViewController? {
        return child?.navigation?.topViewController
    }

    init() {
        
    }

    func launch(window: UIWindow) {
        self.window = window
        startMain()
    }

    func startMain(showTransition: Bool = false) {
        let coordinator = MainCoordinator(with: .init())
        self.window?.rootViewController = coordinator.presenter
        self.window?.makeKeyAndVisible()
        self.child = coordinator
        self.child?.start()
    }
}
