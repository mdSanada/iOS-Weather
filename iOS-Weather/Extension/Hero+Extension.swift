//
//  Hero+Extension.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit
import Hero

extension UIViewController {
    
    // call this in viewWillDisappear(animated:) in the destination view controller when you leave the SHero enabled view controller and you want to disable SHero
    // already added in SViewController
    func disableHero() {
        navigationController?.hero.isEnabled = false
    }
    
    // call this in viewWillAppear(animated:) if you're coming from a view controller that has SHero disabled into a view controller that needs SHero enabled
    // needed if you can navigate back to this view controller with the navigationItem back button
    // already added in SViewController
    func enableHero() {
        hero.isEnabled = true
        navigationController?.hero.isEnabled = true
    }
    
    func showHero(_ viewController: UIViewController, navigation: UINavigationController?, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
        viewController.hero.isEnabled = true
        navigation?.hero.isEnabled = true
        navigation?.hero.navigationAnimationType = navigationAnimationType
        navigation?.pushViewController(viewController, animated: true)
    }
    
    func popHero(navigation: UINavigationController?, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
        let viewController = navigation?.popViewController(animated: true)
        viewController?.hero.isEnabled = true
        navigation?.hero.isEnabled = true
        navigation?.hero.navigationAnimationType = navigationAnimationType
        navigation?.popViewController(animated: true)
    }
}

extension UINavigationController {
    func show(_ viewController: UIViewController, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .fade)) {
        viewController.hero.isEnabled = true
        hero.isEnabled = true
        hero.navigationAnimationType = navigationAnimationType
        pushViewController(viewController, animated: true)
    }
}

//extension Coordinator {
//    func showHero(_ viewController: UIViewController, navigation: UINavigationController, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
//        viewController.hero.isEnabled = true
//        navigation.hero.isEnabled = true
//        navigation.hero.navigationAnimationType = navigationAnimationType
//        navigation.pushViewController(viewController, animated: true)
//    }
//}
