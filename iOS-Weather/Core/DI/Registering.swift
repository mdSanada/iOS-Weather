//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import Foundation
import Resolver
import Moya
import KeychainSwift

extension Resolver: ResolverRegistering {
    static let mock = Resolver(parent: main)

    public static func registerAllServices() {
        register { AppLauncher() as Launcher }
        register { HomeViewModel(with: .initial("")) }
        register { DetailViewModel(with: .initial("")) }
        register { SearchViewModel(with: .initial("")) }
        register { MoyaProvider<Service>() }
    }
}
