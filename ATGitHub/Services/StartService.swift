//
//  OAuthService.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit

class StartService {
    
    static let shared = StartService()

    func start(in window: UIWindow) {
        let tabBarController = createTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabbar = UITabBarController()
        let homeVC = HomeViewController.Factory.build
        let searchVC = SearchViewController.Factory.build
        let historyVC = HistoryViewController.Factory.build
        
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        historyVC.tabBarItem.title = "History"
        historyVC.tabBarItem.image = UIImage(systemName: "clock")
        tabbar.viewControllers = [homeVC, searchVC, historyVC]
        return tabbar
    }
}
