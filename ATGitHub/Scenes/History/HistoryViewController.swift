//
//  HistoryViewController.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit
import RxSwift
import RxCocoa
import OAuthSwift
import SafariServices

class HistoryViewController: DisposeViewController, Storyboarded {
    
    private var dataSource: [SearchResultItem] = []
    private let selectedIndexSubject = PublishSubject<SearchResultItem>()
    var selectedIndex: Observable<SearchResultItem> {
        return selectedIndexSubject.asObservable()
    }
    
    @IBOutlet private(set) var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let data = try? UserDefaultsStorage().getData(castTo: [SearchResultItem].self) {
            dataSource = data
            tableView.reloadData()
        }
    }
}

extension HistoryViewController: StaticFactory {
    enum Factory {
        static var build: HistoryViewController {
            let repositories = try? UserDefaultsStorage().getData(castTo: [SearchResultItem].self)
            let viewController = HistoryViewController.instantiate()
            let driver = HistoryDriver.Factory.build(repositories: repositories)
            let actionBinder = HistoryActionBinder(viewController: viewController, driver: driver)
            let stateBinder = HistoryStateBinder(viewController: viewController, driver: driver)
            let navigationBinder = DismissBinder<HistoryViewController>.Factory
                .dismiss(viewController: viewController, driver: driver.didClose)
            let navigationBinder2 = NavigationPushBinder<SearchResultItem, HistoryViewController>.Factory
                .present(viewController: viewController,
                      driver: driver.didSelect,
                      factory: repositorySavaryViewController)
            
            viewController.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder,
                navigationBinder2
            )
            
            return viewController
        }
        
        private static func repositorySavaryViewController(_ item: SearchResultItem) -> UIViewController {
            return SFSafariViewController(url: URL(string: item.url)!)
        }
    }
}


extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func setDataSource(_ dataSource: [SearchResultItem]) {
        self.dataSource = dataSource
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultItemTableViewCell.identifier,
                                                 for: indexPath) as! SearchResultItemTableViewCell
        cell.configure(withRepoItem: dataSource[indexPath.row], selectedItems: [])
        //Времмено пока не починю звезды
        cell.setStarView.isHidden = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexSubject.onNext(dataSource[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
