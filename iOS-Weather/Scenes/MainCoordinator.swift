//
//  TemplateCoordinator.swift
//  IOS-Recovery
//
//  Created by xds-colaborator on 10/03/20.
//  Copyright © 2020 Eduardo Paganini. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var presenter: UIViewController
    var child: Coordinator?

    init(with navigation: UINavigationController) {
        self.presenter = navigation
        self.navigation?.isNavigationBarHidden = true
    }

    func start() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : HomeViewController = storyboard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        viewController.delegate = self
        navigation?.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: HomeDelegate {
    func navigateToDetails(weather: Weather, forecast: Forecast, indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : DetailViewController = storyboard.instantiateViewController(withIdentifier: "details") as! DetailViewController
        viewController.weather = weather
        viewController.forecast = forecast
        viewController.backgroundImageHeroId = "background-\(indexPath.row)-\(indexPath.section)"
        self.navigation?.show(viewController)
    }
    
    func pushSearch(controller: HomeViewController) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : SearchViewController = storyboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
        viewController.delegate = controller
        self.navigation?.present(viewController, animated: true, completion: nil)
    }
}
