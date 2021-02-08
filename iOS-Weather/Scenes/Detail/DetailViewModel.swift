//
//  DetailViewModel.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

class DetailViewModel: BaseDetailVM {
    
    override func mutate(with intent: DetailIntention) {
        switch intent {
        case let .getDays(forecast):
            self.getDays(forecast: forecast)
        case let .getHours(forecast):
            self.getHours(forecast: forecast)
        }
    }
    
    override func reduce(with prevState: DetailViewState, _ mutation: DetailMutation) -> DetailViewState {
        switch mutation {
        case let .resultDays(days):
            return .resultDays(days)
        case let .resultHours(hours):
            return .resultHours(hours)
        }
    }
}

extension DetailViewModel {
    fileprivate func getHours(forecast: Forecast) {
        let list = forecast.list
        var listWithDate: [ForecastHour] = []
        for item in list {
            let date = item.dt.intervalToDate()
            if date.isToday() {
                listWithDate.append(ForecastHour(hour: date,
                                                 temp: item.main.temp,
                                                 icon: (item.weather.first?.icon.getIcon())!))
            }
        }
        emit(.resultHours(listWithDate))
        print(listWithDate)
    }
    
    fileprivate func getDays(forecast: Forecast) {
        let list = forecast.list
        var listWithDate: [ForecastDay] = []
        var dateList: [Date] = []
        for (index, _) in list.enumerated() {
            if (index + 1) < list.count {
                if !(list[index].dt.intervalToDate().isSame(of: list[index + 1].dt.intervalToDate()))
                    || index == 0 {
                    let day = list[index].dt.intervalToDate()
                    var calendar = Calendar.current
                    guard let timezone = TimeZone(abbreviation: "UTC") else { return  }
                    calendar.timeZone = timezone
                    guard let newDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: day) else { return }
                    dateList.append(newDate)
                }
            }
        }
        
        for date in dateList {
            var dayForecast: [Double] = []
            var safeDate: Date = Date()
            var image: [UIImage] = []
            for item in list {
                let newDate = item.dt.intervalToDate()
                if newDate.isSame(of: date) {
                    safeDate = date
                    dayForecast.append(item.main.temp)
                    image.append((item.weather.first?.icon.getIcon())!)
                }
            }
            listWithDate.append(ForecastDay(day: safeDate,
                                            temp: getAverage(list: dayForecast),
                                            icon: (image.first ?? UIImage(systemName: "exclamationmark.triangle"))!))
        }
        listWithDate.remove(at: 0)
        emit(.resultDays(listWithDate))
    }
    
    func getAverage(list: [Double]) -> Double {
        return list.reduce(0.0) {
            return $0 + $1/Double(list.count)
        }
    }
}
