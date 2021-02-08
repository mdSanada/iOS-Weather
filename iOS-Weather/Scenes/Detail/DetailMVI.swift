//
//  DetailMVI.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation

enum DetailIntention: Intent {
    case getDays(Forecast)
    case getHours(Forecast)
}

enum DetailMutation: Mutation {
    case resultDays([ForecastDay])
    case resultHours([ForecastHour])
}

enum DetailViewState: ViewState {
    case initial(String?)
    case resultDays([ForecastDay])
    case resultHours([ForecastHour])
}


typealias BaseDetailVM = BaseViewModel<DetailIntention, DetailMutation, DetailViewState>
typealias BaseDetailVC = BaseViewController<DetailIntention, DetailMutation, DetailViewState, DetailViewModel>
