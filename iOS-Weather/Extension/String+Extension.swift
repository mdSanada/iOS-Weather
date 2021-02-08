//
//  String+Extension.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 05/02/21.
//

import UIKit

extension String {
    func getIcon() -> UIImage {
        let str: String = self
        switch str {
        case "01d":
            return UIImage(systemName: "sun.max")!
        case "02d":
            return UIImage(systemName: "cloud.sun")!
        case "03d":
            return UIImage(systemName: "cloud")!
        case "04d":
            return UIImage(systemName: "cloud.fill")!
        case "09d":
            return UIImage(systemName: "cloud.rain")!
        case "10d":
            return UIImage(systemName: "cloud.sun.rain")!
        case "11d":
            return UIImage(systemName: "cloud.bolt")!
        case "13d":
            return UIImage(systemName: "snow")!
        case "50d":
            return UIImage(systemName: "cloud.fog")!
        case "01n":
            return UIImage(systemName: "moon")!
        case "02n":
            return UIImage(systemName: "cloud.moon")!
        case "03n":
            return UIImage(systemName: "cloud")!
        case "04n":
            return UIImage(systemName: "cloud.fill")!
        case "09n":
            return UIImage(systemName: "cloud.rain")!
        case "10n":
            return UIImage(systemName: "cloud.moon.rain")!
        case "11n":
            return UIImage(systemName: "cloud.bolt")!
        case "13n":
            return UIImage(systemName: "cloud.fog")!
        case "50n":
            return UIImage(systemName: "snow")!
        default:
            return UIImage(systemName: "exclamationmark.triangle")!
        }
    }
}
