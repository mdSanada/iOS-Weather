//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//

import Moya
import ObjectiveC
import KeychainSwift

private var authorizationTypeAssociationKey: UInt8 = 0
private let keychain = KeychainSwift()

extension MoyaProvider {
    convenience init() {
        let networkActivityPlugin = NetworkActivityPlugin { activityChangeType, _ in
            switch activityChangeType {
            case .began:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            case .ended:
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        let plugins: [PluginType] = [NetworkLoggerPlugin(), networkActivityPlugin]

        self.init(
            session: DefaultSessionManager.shared,
            plugins: plugins)
    }
}
