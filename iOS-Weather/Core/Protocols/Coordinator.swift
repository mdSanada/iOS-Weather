//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import UIKit

protocol Coordinator: class {
    var presenter: UIViewController { get }
    var navigation: UINavigationController? { get }
    var child: Coordinator? { get set }

    func start()
}

extension Coordinator {
    var navigation: UINavigationController? {
        return presenter as? UINavigationController
    }
}
