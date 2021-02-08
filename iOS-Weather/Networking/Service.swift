//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import Foundation
import Moya
import KeychainSwift

enum Service {
    case getWeather(lat: String, lon: String)
    case getForecast(lat: String, lon: String)
    case searchCity(city: String)
}

extension Service: TargetType {
    var baseURL: URL {
        switch self {
        case let .searchCity(city):
            let accessKey = "access_key=36f49f4e8d667a5423f97f0a5ee41a4b"
            let trimmedCity = city.replacingOccurrences(of: " ", with: "")
            return URL(string: "http://api.positionstack.com/v1/forward?\(accessKey)&query=\(trimmedCity)")!
        case let .getForecast(lat, lon):
            let coordinate = "lat=\(lat)&lon=\(lon)"
            let units = "units=metric"
            let lang = "lang=pt_br"
            let appid = "appid=71523b24e8b559a4cae5ce89fe423942"
            return URL(string: "https://api.openweathermap.org/data/2.5/forecast?\(coordinate)&\(units)&\(lang)&\(appid)")!
        case let .getWeather(lat, lon):
            let coordinate = "lat=\(lat)&lon=\(lon)"
            let units = "units=metric"
            let lang = "lang=pt_br"
            let appid = "appid=71523b24e8b559a4cae5ce89fe423942"
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?\(coordinate)&\(units)&\(lang)&\(appid)")!
        default:
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?")!
        }
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }

    var sampleData: Data {
        switch self {
        case .getWeather:
            let path = Bundle.main.path(forResource: "home_result", ofType: "json")!
            return try! Data(contentsOf: URL(fileURLWithPath: path))
        case .getForecast:
            let path = Bundle.main.path(forResource: "forecast_result", ofType: "json")!
            return try! Data(contentsOf: URL(fileURLWithPath: path))
        case .searchCity:
            let path = Bundle.main.path(forResource: "search_result", ofType: "json")!
            return try! Data(contentsOf: URL(fileURLWithPath: path))
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Task {
        var params: [String: Any] = [:]

        switch self {
        default:
            break
        }
        
        switch self {
        default:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-type": "application/json;charset=utf-8",
            "X-Channel": "ios"
        ]
    }
}
