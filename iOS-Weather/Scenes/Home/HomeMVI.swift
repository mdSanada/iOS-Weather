//
//  HomeMVI.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

enum HomeIntention: Intent {
    case getActualWeather(Coordinate)
    case getChosedWeather(Coordinate)
    case getRecommendedWeather([Coordinate])
    case checkStatus(Weather?, [Weather], Int)
    case getForecast(IndexPath, lat: String, lon: String)
}

enum HomeMutation: Mutation {
    case successActual(Weather)
    case successRecommended(Weather)
    case successForecast(Forecast, IndexPath)
    case successChosed(Weather)
    case errorChosed(Error)
    case success
    case error(Error)
    case errorForecast(Error)
    case isLoading(Bool)
    
}

enum HomeViewState: ViewState {
    case initial(String?)
    case successActual(Weather)
    case successRecommended(Weather)
    case successForecast(Forecast, IndexPath)
    case successChosed(Weather)
    case errorChosed(Error)
    case success
    case error(Error)
    case errorForecast(Error)
    case isLoading(Bool)
}


typealias BaseHomeVM = BaseViewModel<HomeIntention, HomeMutation, HomeViewState>
typealias BaseHomeVC = BaseViewController<HomeIntention, HomeMutation, HomeViewState, HomeViewModel>
