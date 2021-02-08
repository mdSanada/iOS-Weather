//
//  SearchMVI.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import Foundation

enum SearchIntention: Intent {
    case search(String)
}

enum SearchMutation: Mutation {
    case isLoading(Bool)
    case success(SearchLocationModel)
    case error(Error)
}

enum SearchViewState: ViewState {
    case initial(String?)
    case isLoading(Bool)
    case success(SearchLocationModel)
    case error(Error)
}


typealias BaseSearchVM = BaseViewModel<SearchIntention, SearchMutation, SearchViewState>
typealias BaseSearchVC = BaseViewController<SearchIntention, SearchMutation, SearchViewState, SearchViewModel>
