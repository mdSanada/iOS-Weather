//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import Foundation
import Moya
import RxSwift

extension Single where Element == Response {
    func tryToMap<D: Decodable>(_ type: D.Type) -> Single<D> {
        return self.asObservable().map { response in
            if (200...299).contains(response.statusCode) {
                let formatter = formatterPtBr("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(formatter)
                do {
                    return try response.map(type, using: decoder)
                } catch {
                    debugPrint(error)
                }
            }
            if response.statusCode == 401 {
            }
            throw (try? response.map(ResponseError.self)) ?? .unexpected()
        }.asSingle()
    }
}
