//
//  HomeViewModel.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation
import Resolver
import RxSwift
import CocoaLumberjack
import Moya

class HomeViewModel: BaseHomeVM {
    fileprivate let provider: MoyaProvider<Service> = Resolver.resolve()

    override func mutate(with intent: HomeIntention) {
        switch intent {
        case let .getActualWeather(coordinate):
            self.getActualWeather(coordinate.lat, coordinate.lon)
        case let .getRecommendedWeather(coordinates):
            for coordinate in coordinates {
                self.getListWeather(coordinate.lat, coordinate.lon)
            }
        case let .checkStatus(actual, recommended, count):
            checkStatus(actual: actual, recommended: recommended, count: count)
        case let .getForecast(index, lat, lon):
            self.getForecast(index: index, lat: lat, lon: lon)
        case let .getChosedWeather(coordinate):
            self.getChosedWeather(coordinate.lat, coordinate.lon)
        }
    }
    
    override func reduce(with prevState: HomeViewState, _ mutation: HomeMutation) -> HomeViewState {
        switch mutation {
        case let .successActual(weather):
            return .successActual(weather)
        case let .error(error):
            return .error(error)
        case let .isLoading(isLoading):
            return .isLoading(isLoading)
        case let .successRecommended(weather):
            return .successRecommended(weather)
        case .success:
            return .success
        case let .successForecast(forecast, index):
            return .successForecast(forecast, index)
        case let .errorForecast(error):
            return .error(error)
        case let .successChosed(success):
            return .successChosed(success)
        case let .errorChosed(error):
            return .errorChosed(error)
        }
    }
}

extension HomeViewModel {
    fileprivate func checkStatus(actual: Weather?, recommended: [Weather], count: Int) {
        if actual != nil && recommended.count == 3 {
            emit(.isLoading(false))
            emit(.success)
        }
    }
    
    fileprivate func getChosedWeather(_ lat: String,_ lon: String) {
        emit(.isLoading(true))
        provider.rx.request(.getWeather(lat: lat, lon: lon))
            .tryToMap(Weather.self)
            .subscribe(
                onSuccess: { value in
                    self.emit(.successChosed(value))
                    self.emit(.isLoading(false))
                },
                onError: { value in
                    self.emit(.errorChosed(value))
                    self.emit(.isLoading(false))
                } )
            .disposed(by: disposeBag)
    }
    
    fileprivate func getActualWeather(_ lat: String,_ lon: String) {
        emit(.isLoading(true))
        provider.rx.request(.getWeather(lat: lat, lon: lon))
            .tryToMap(Weather.self)
            .subscribe(
                onSuccess: { value in
                    self.emit(.successActual(value))
                },
                onError: { value in
                    self.emit(.error(value))
                } )
            .disposed(by: disposeBag)
    }
    
    fileprivate func getListWeather(_ lat: String,_ lon: String) {
        emit(.isLoading(true))
        provider.rx.request(.getWeather(lat: lat, lon: lon))
            .tryToMap(Weather.self)
            .subscribe(
                onSuccess: { value in
                    self.emit(.successRecommended(value))
                },
                onError: { value in
                    self.emit(.error(value))
                } )
            .disposed(by: disposeBag)
    }
    
    fileprivate func getForecast(index: IndexPath, lat: String, lon: String) {
        provider.rx.request(.getForecast(lat: lat, lon: lon))
            .tryToMap(Forecast.self)
            .subscribe(
                onSuccess: { value in
                    self.emit(.successForecast(value, index))
                },
                onError: { value in
                    self.emit(.errorForecast(value))
                } )
            .disposed(by: disposeBag)
    }
}
