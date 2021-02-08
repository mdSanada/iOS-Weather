//
//  AppDelegate.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//


import UIKit
import RxSwift
import RxCocoa
import RxOptional
import CocoaLumberjack
import Resolver

class BaseViewController<I: Intent, M: Mutation, VS: ViewState, VM: BaseViewModel<I, M, VS>>: UIViewController, ViewConfigurator {
    let disposeBag: DisposeBag = .init()
    let viewModel: VM = Resolver.resolve()

    func mutate(_ intention: I) { viewModel.intent.on(.next(intention)) }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewState
            .map { Optional($0) }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .drive(onNext: (render))
            .disposed(by: disposeBag)
        executeViewConfigurator()
    }

    open func render(_ viewState: VS) {
        fatalError("render() must be overridden in concrete implementations of ViewController")
    }

    open func executeViewConfigurator() {
        addViewHierarchy()
        setupConstraints()
        configureViews()
        configureBindings()
        fetch()
    }

    final func mockStateViewModel(with initialState: VS) -> MockViewModel<I, M, VS> {
        let mock = viewModel.mock(with: initialState)
        mock.viewState
            .map { Optional($0) }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .do(onNext: {
                debugPrint(">>> Value \($0)")
            })
            .drive(onNext: (render))
            .disposed(by: disposeBag)
        return mock
    }

    open func addViewHierarchy() {}
    open func setupConstraints() {}
    open func configureViews() {}
    open func configureBindings() {}
    open func fetch() {}
}
