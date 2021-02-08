//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import Foundation

protocol ViewConfigurator: class {
    func executeViewConfigurator()
    func addViewHierarchy()
    func setupConstraints()
    func configureViews()
    func configureBindings()
    func fetch()
}
