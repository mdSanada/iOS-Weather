//
//  SearchViewModel.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit
import Resolver
import RxSwift
import Moya

class SearchViewModel: BaseSearchVM {
    fileprivate let provider: MoyaProvider<Service> = Resolver.resolve()

    override func mutate(with intent: SearchIntention) {
        switch intent {
        case let .search(city):
            self.search(city: city)
        }
    }
    
    override func reduce(with prevState: SearchViewState, _ mutation: SearchMutation) -> SearchViewState {
        switch mutation {
        case let .isLoading(isLoading):
            return .isLoading(isLoading)
        case let .success(success):
            return .success(success)
        case let .error(error):
            return .error(error)
        }
    }
}

extension SearchViewModel {
    func search(city: String) {
        emit(.isLoading(true))
        provider.rx.request(.searchCity(city: city))
            .tryToMap(SearchLocationModel.self)
            .subscribe(
                onSuccess: { value in
                    self.emit(.success(value))
                },
                onError: { value in
                    self.emit(.error(value))
                } )
            .disposed(by: disposeBag)
    }
}
