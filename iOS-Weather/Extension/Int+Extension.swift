//
//  Int+Extensions.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation

extension Int {
    func toCelsius() -> String {
        return String(self) + "°C"
    }
    
    func toPercentage() -> String {
        return String(self) + "%"
    }
    
    func intervalToString() -> String {
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: sunriseDate)
    }
    
    func intervalToDate() -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date
    }

}

extension Double {
    func toCelsius() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        formatter.locale = Locale(identifier: "pt_BR")

        return (formatter.string(from: NSNumber(value: Double(self)))?.trimmingCharacters(in: .whitespaces) ?? "") + "°C"
    }
    
    func toCelsiusRedonded() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        formatter.locale = Locale(identifier: "pt_BR")
        
        return (formatter.string(from: NSNumber(value: Double(self)))?.trimmingCharacters(in: .whitespaces) ?? "") + "°C"
    }
}
