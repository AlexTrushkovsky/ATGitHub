//
//  HomeViewController.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 02.01.2022.
//

import UIKit
import RxSwift
import RxCocoa
import OAuthSwift
import SafariServices
import Nuke

final class HomeViewController: DisposeViewController, Storyboarded {
    @IBOutlet private(set) var userNameLabel: UILabel!
    @IBOutlet private(set) var userCompanyLabel: UILabel!
    @IBOutlet private(set) var userImage: UIImageView!
    @IBOutlet private(set) var activityTableView: UITableView!
    @IBOutlet private(set) var starredCollectionView: UICollectionView!
    
    private var activityDataSource: [HomeActivityResultItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.activityTableView.reloadData()
            }
        }
    }
    private var starredDataSource: [HomeStarredResultItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.starredCollectionView.reloadData()
            }
        }
    }
    
    private var oAuthService: OAuthServiceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oAuthService = OAuthService(viewController: self)
        activityTableView.register(HomeActivityCell.cellNib, forCellReuseIdentifier: HomeActivityCell.identifier)
        starredCollectionView.register(HomeStarredCell.cellNib, forCellWithReuseIdentifier: HomeStarredCell.identifier)
        activityTableView.dataSource = self
        activityTableView.delegate = self
        activityTableView.separatorStyle = .none
        starredCollectionView.dataSource = self
        starredCollectionView.delegate = self
    }
    
    private func fetchData() {
        let apiService = GitHubAPIService()
        apiService.getCurrentUser { user in
            DispatchQueue.main.async {
                self.userCompanyLabel.text = user?.company
                if let imageURL = user?.avatarURL {
                    Nuke.loadImage(with: URL(string: imageURL)!, into: self.userImage)
                    self.userImage.cornerRadius = self.userImage.layer.frame.height/2
                    self.userImage.borderColor = .systemBlue
                    self.userImage.borderWidth = 2
                }
            }
            
            apiService.getStarredByUser { starredRepos in
                if let starredRepos = starredRepos {
                    self.starredDataSource.removeAll()
                    for repo in starredRepos {
                        self.starredDataSource.append(HomeStarredResultItem(starredRepo: repo))
                    }
                }
            }
            if let userName = user?.login {
                DispatchQueue.main.async {
                    self.userNameLabel.text = userName
                }
                
                apiService.getLastActivity(userName: userName) { lastEvents in
                    if let lastEvents = lastEvents {
                        self.activityDataSource.removeAll()
                        for event in lastEvents {
                            self.activityDataSource.append(HomeActivityResultItem(event: event))
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        oAuthService?.isAuthorized(completion: { bool in
            print("Bool \(bool)")
            if !bool {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    vc.modalPresentationStyle = .fullScreen
                    self.tabBarController?.present(vc, animated: true, completion: nil)
                }
            }
        })
    }
}

extension HomeViewController: StaticFactory {
    enum Factory {
        static var build: HomeViewController {
            let viewController = HomeViewController.instantiate()
            return viewController
        }
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func setActivityDataSource(_ dataSource: [HomeActivityResultItem]) {
        self.activityDataSource = dataSource
        activityTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeActivityCell.identifier,
                                                 for: indexPath) as! HomeActivityCell
        cell.configure(withRepoItem: activityDataSource[indexPath.row])
        return cell
    }
    
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starredDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStarredCell.identifier,
                                                 for: indexPath) as! HomeStarredCell
        cell.configure(withRepoItem: starredDataSource[indexPath.row])
        return cell
    }
    
    func setStarredDataSource(_ dataSource: [HomeStarredResultItem]) {
        self.starredDataSource = dataSource
        starredCollectionView.reloadData()
    }
    
}
