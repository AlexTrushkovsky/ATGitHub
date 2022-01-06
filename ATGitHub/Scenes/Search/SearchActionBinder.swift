//
//  SearchActionBinder.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchActionBinder: ViewControllerBinder {
    unowned let viewController: SearchViewController
    private let driver: SearchDriverProtocol
    
    init(viewController: SearchViewController, driver: SearchDriverProtocol) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() { }
    
    func bindLoaded() {
        let select = viewController
            .selectedIndex
            .asDriver(onError: SearchResultItem())
        
        let query = viewController.searchField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        
        viewController.bag.insert(
            select
                .drive(onNext: driver.select),
            query
                .bind(onNext: driver.search)
        )
    }
}
