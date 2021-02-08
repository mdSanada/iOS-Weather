//
//  SeatchModel.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 05/02/21.
//

import Foundation

// MARK: - SearchLocationModel
struct SearchLocationModel: Codable {
    var data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let label: String?
    let county: String?
    let latitude, longitude: Double?
    let region: String?
    let country: String?
}
