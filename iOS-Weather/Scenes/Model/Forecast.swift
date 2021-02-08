//
//  Forecast.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ListF]
    let city: CityF
}

// MARK: - City
struct CityF: Codable {
    let id: Int
    let name: String
    let coord: CoordF
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct CoordF: Codable {
    let lat, lon: Double
}

// MARK: - List
struct ListF: Codable {
    let dt: Int
    let main: MainClassF
    let weather: [WeatherF]
    let clouds: CloudsF
    let wind: WindF
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain, snow: RainF?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

// MARK: - Clouds
struct CloudsF: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClassF: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct RainF: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct SysF: Codable {
    let pod: PodF
}

enum PodF: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct WeatherF: Codable {
    let id: Int
    let main: MainEnumF
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnumF: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
}

// MARK: - Wind
struct WindF: Codable {
    let speed: Double
    let deg: Int
}
