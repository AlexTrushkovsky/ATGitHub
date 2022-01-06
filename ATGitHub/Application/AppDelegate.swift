//
//  AppDelegate.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 02.01.2022.
//

import UIKit
import OAuthSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            StartService.shared.start(in: window)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        OAuthSwift.handle(url: url)
        return true
    }


}

