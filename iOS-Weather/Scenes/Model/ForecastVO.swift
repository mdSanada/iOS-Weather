//
//  ForecastVO.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

struct ForecastHour {
    let hour: Date
    let temp: Double
    let icon: UIImage
}

struct ForecastDay {
    let day: Date
    let temp: Double
    let icon: UIImage
}
