//
//  HistoryActionBinder.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

final class HistoryActionBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriverProtocol
    
    init(viewController: HistoryViewController,
         driver: HistoryDriverProtocol) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        let select = viewController
            .selectedIndex
            .asDriver(onError: SearchResultItem())

        viewController.bag.insert(
            select
                .drive(onNext: driver.select)
        )
    }
}
