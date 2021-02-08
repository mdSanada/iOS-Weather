//
//  Date+Extension.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation
import RxSwift

extension Single {
    func formatterPtBr(_ pattern: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "pt-br")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = pattern
        return formatter
    }
}
