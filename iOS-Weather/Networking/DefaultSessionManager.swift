//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import Foundation
import Alamofire

final class DefaultSessionManager: Session {
  static let shared: DefaultSessionManager = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 20
    configuration.timeoutIntervalForResource = 20
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return .init(configuration: configuration)
  }()
}
