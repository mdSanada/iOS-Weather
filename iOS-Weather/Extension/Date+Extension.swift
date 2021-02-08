//
//  Date+Extension.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

extension Date {
    public func dateFormatted() -> String {
        let formatter = formatterPtBr("dd/MM/yyyy")
        return formatter.string(from: self)
    }
    
    public func dateAPIFormatted() -> String {
        let formatter = formatterPtBr("yyyy-MM-dd")
        return formatter.string(from: self)
    }
    
    public func dateFormattedExtended() -> String {
        let formatter = formatterPtBr("dd 'de' MMMM 'de' yyyy, HH:mm")
        return formatter.string(from: self)
    }
    
    public func dateFormattedHour() -> String {
        let formatter = formatterPtBr("HH:mm")
        return formatter.string(from: self)
    }

    
    func formatterPtBr(_ pattern: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "pt-br")
        formatter.timeZone = .current//TimeZone(abbreviation: "UTC")
        formatter.dateFormat = pattern
        return formatter
    }
    
    func now() -> Date {
        var calendar = Calendar.current
        guard let timezone = TimeZone(abbreviation: "UTC") else { return .init() }
        calendar.timeZone = timezone
        let now = calendar.date(bySettingHour: 3, minute: 0, second: 0, of: .init())
        return now ?? .init()
    }
    
    func isToday() -> Bool {
        return self.isSame(of: now())
    }
    
    func isSameAdding(by value: Int) -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: value, to: now())!
        return self.isSame(of: tomorrow)
    }
    
    func isSame(of date: Date) -> Bool {
        let order = NSCalendar.current.compare(self, to: date, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    func getDayPeriod() -> UIImage {
        let formatter = formatterPtBr("HH")
        guard var hour = Int(formatter.string(from: self)) else { return UIImage(systemName: "sun")!}
        hour = hour - 3
        if hour >= 00 && hour < 6 {
            return UIImage(named: "noon")!
        } else if hour >= 6 && hour < 12 {
            return UIImage(named: "morning")!
        } else if hour >= 12 && hour < 18 {
            return UIImage(named: "afternoon")!
        } else {
            return UIImage(named: "night")!
        }
    }
    
    func getPrimaryColor() -> UIColor {
        let formatter = formatterPtBr("HH")
        guard var hour = Int(formatter.string(from: self)) else { return .white }
        hour = hour - 3
        if hour >= 00 && hour < 6 {
            return UIColor(named: "primaryNoon")!
        } else if hour >= 6 && hour < 12 {
            return UIColor(named: "primaryMorning")!
        } else if hour >= 12 && hour < 18 {
            return UIColor(named: "primaryAfternoon")!
        } else {
            return UIColor(named: "primaryNight")!
        }
    }
    
    func getSecondaryColor() -> UIColor {
        let formatter = formatterPtBr("HH")
        guard var hour = Int(formatter.string(from: self)) else { return .white }
        hour = hour - 3
        if hour >= 00 && hour < 6 {
            return UIColor(named: "white")!
        } else if hour >= 6 && hour < 12 {
            return UIColor(named: "white")!
        } else if hour >= 12 && hour < 18 {
            return UIColor(named: "black")!
        } else {
            return UIColor(named: "white")!
        }
    }
    
    func getSecondaryAccentColor() -> UIColor {
        let formatter = formatterPtBr("HH")
        guard var hour = Int(formatter.string(from: self)) else { return .white }
        hour = hour - 3
        if hour >= 00 && hour < 6 {
            return UIColor(named: "black")!
        } else if hour >= 6 && hour < 12 {
            return UIColor(named: "black")!
        } else if hour >= 12 && hour < 18 {
            return UIColor(named: "white")!
        } else {
            return UIColor(named: "black")!
        }
    }

    func getBackgroundColor() -> UIColor {
        let formatter = formatterPtBr("HH")
        guard var hour = Int(formatter.string(from: self)) else { return .white }
        hour = hour - 3
        if hour >= 00 && hour < 6 {
            return UIColor(named: "noon")!
        } else if hour >= 6 && hour < 12 {
            return UIColor(named: "morning")!
        } else if hour >= 12 && hour < 18 {
            return UIColor(named: "afternoon")!
        } else {
            return UIColor(named: "night")!
        }
    }

}

