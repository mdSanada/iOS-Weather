//
//  ResponseError.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation

struct ResponseError: Codable, Error {
    let statusCode: Int
    let message: String
}

extension ResponseError {
    static func unexpected() -> ResponseError {
        return ResponseError(statusCode: -1, message: "Erro!")
    }
}
