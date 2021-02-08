//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import Foundation
import RxSwift
import RxCocoa
import CocoaLumberjack
import KeychainSwift

class BaseViewModel<I: Intent, M: Mutation, VS: ViewState> {
    fileprivate let stateSubject: BehaviorSubject<VS>
    fileprivate let mutationSubject = PublishSubject<M>()
    internal let disposeBag = DisposeBag()

    lazy var viewState: Observable<VS> = {
        DDLogVerbose("> viewState")
        return self.stateSubject.asObservable()
    }()

    var intent: Binder<I> {
        return .init(self) { base, intent in
            DDLogVerbose("> Send intent: \(intent)")
            base.mutate(with: intent)
        }
    }

    var keychain: KeychainSwift {
        return KeychainSwift()
    }
    
    func emit(_ mutation: M) { mutationSubject.onNext(mutation) }

    init(with initialState: VS) {
        self.stateSubject = BehaviorSubject(value: initialState)
        mutationSubject
            .scan(initialState) { [unowned self] previousViewState, mutation in
                self.reduce(with: previousViewState, mutation)
            }
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
    }

    open func mutate(with intent: I) {
        fatalError("mutate(with intent: Intent) must be overridden in concrete implementations of ViewModel")
    }

    open func reduce(with prevState: VS, _ mutation: M) -> VS {
        fatalError("reduce(with previousViewState: ViewState, _ mutation: Mutation) must be overridden in concrete implementations of ViewModel")
    }
}

// MARK: - MOCK
class MockViewModel<I: Intent, M: Mutation, VS: ViewState> : BaseViewModel<I, M, VS> {
    fileprivate override init(with initialState: VS) {
        super.init(with: initialState)
    }

    func onNext(state: VS) {
        self.stateSubject.onNext(state)
    }
}

extension BaseViewModel {
    func  mock(with initialState: VS) -> MockViewModel<I, M, VS> {
        stateSubject.onCompleted()
        return MockViewModel(with: initialState)
    }
}
