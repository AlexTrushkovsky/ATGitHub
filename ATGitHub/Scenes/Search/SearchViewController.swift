//
//  SearchViewController.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit
import RxSwift
import SafariServices

final class SearchViewController: DisposeViewController, Storyboarded {
    @IBOutlet private(set) var searchField: UITextField!
    @IBOutlet private(set) var tableView: UITableView!
    private var dataSource: [SearchResultItem] = []
    private var starredRepos: [RepositoryEntity] = []
    private var selectedRepos = [SearchResultItem]() {
        didSet { tableView.reloadData() }
    }
    
    private let selectedIndexSubject = PublishSubject<SearchResultItem>()
    private let selectedIndexesSubject = PublishSubject<[SearchResultItem]>()
    
    var selectedIndex: Observable<SearchResultItem> {
        return selectedIndexSubject.asObservable()
    }
    
    var selectedIndexes: Observable<[SearchResultItem]> {
        return selectedIndexesSubject.asObservable()
    }
    
    let storage = UserDefaultsStorage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.searchField.cornerRadius = 15
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.searchField.leftView = paddingView
        self.searchField.leftViewMode = .always
        //Переделать
        GitHubAPIService().getStarredByUser { starredRepos in
            if let starredRepos = starredRepos {
                self.starredRepos = starredRepos
            }
        }
        if let repos = try? storage.getData(castTo: [SearchResultItem].self) {
            self.selectedRepos = repos
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchField.becomeFirstResponder()
    }
}

extension SearchViewController: StaticFactory {
    enum Factory {
        static var build: SearchViewController {
            let viewController = SearchViewController.instantiate()
            let driver = SearchDriver.Factory.build
            let actionBinder = SearchActionBinder(viewController: viewController, driver: driver)
            let stateBinder = SearchStateBinder.Factory.build(viewController, driver: driver)
            let navigationBinder = NavigationPushBinder<SearchResultItem, SearchViewController>.Factory
                .present(viewController: viewController, driver: driver.didSelect, factory: repositorySavaryViewController)
            viewController.bag.insert(
                stateBinder,
                actionBinder,
                navigationBinder
            )
            return viewController
        }
        
        private static func repositorySavaryViewController(_ item: SearchResultItem) -> UIViewController {
            return SFSafariViewController(url: URL(string: item.url)!)
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
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
        let repoItem = dataSource[indexPath.row]
        cell.configure(withRepoItem: dataSource[indexPath.row], selectedItems: selectedRepos)
        cell.isStarred = starredRepos.contains(where: { $0.id == repoItem.id })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = dataSource[indexPath.row]
        if !selectedRepos.contains(where: { $0.id == selectedRepo.id }) {
            if var repositories = try? storage.getData(castTo: [SearchResultItem].self) {
                repositories.insert(selectedRepo, at: 0)
                if repositories.count > 20 {
                    repositories.removeLast()
                }
                try? storage.saveData(repositories)
            } else {
                try? storage.saveData([selectedRepo])
            }
            
            selectedRepos.append(selectedRepo)
        }
            
        selectedIndexSubject.onNext(dataSource[indexPath.row])
        selectedIndexesSubject.onNext(selectedRepos)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
