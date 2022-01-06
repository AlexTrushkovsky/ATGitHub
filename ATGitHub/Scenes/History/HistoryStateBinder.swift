//
//  HistoryStateBinder.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit

final class HistoryStateBinder: ViewControllerBinder {
    unowned let viewController: HistoryViewController
    private let driver: HistoryDriverProtocol
    
    init(viewController: HistoryViewController,
         driver: HistoryDriverProtocol) {
        self.viewController = viewController
        self.driver = driver
        bind()
    }
    
    func dispose() {}
    
    func bindLoaded() {
        viewController.tableView.register(SearchResultItemTableViewCell.cellNib, forCellReuseIdentifier: SearchResultItemTableViewCell.identifier)

        viewController.bag.insert(
            viewController.rx.viewWillAppear
                .bind(onNext: { [weak self] in self?.viewWillAppear($0) }),
            driver.data
                .drive(onNext: { [weak self] in self?.configure($0) })
        )
    }
    
    private func viewWillAppear(_ animated: Bool) {
        viewController.tableView.tableFooterView = UIView()
    }
    
    private func configure(_ repositories: [SearchResultItem]) {
        let lastTwentyRepositories = repositories.suffix(20)
            .reversed()
        viewController.setDataSource(Array(lastTwentyRepositories))
    }
}
