//
//  OAuthService.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit
import OAuthSwift
import RxSwift
import RxCocoa

protocol OAuthServiceProtocol {
    func loadOAuth()
    func isAuthorized(completion: @escaping ((Bool) -> ()))
}

class OAuthService {
    
    private let oauthswift: OAuth2Swift
    unowned let viewController: UIViewController
    private let storage: APIStorage
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        self.storage = UserDefaultsStorage()
        self.oauthswift = OAuth2Swift(
            consumerKey:    Configuration.OAuthCredentials.clientID,
            consumerSecret: Configuration.OAuthCredentials.clientSecret,
            authorizeUrl:   Configuration.OAuthCredentials.authorizeUrl,
            accessTokenUrl: Configuration.OAuthCredentials.accessTokenUrl,
            responseType:   Configuration.OAuthCredentials.token
        )
    }
}

extension OAuthService: OAuthServiceProtocol {
    
    func isAuthorized(completion: ((Bool) -> ())) {
        if self.storage.token != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func loadOAuth() {
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)
        guard let rwURL = URL(string: Configuration.OAuthCredentials.urlScheme) else { return }
        oauthswift.authorize(withCallbackURL: rwURL, scope: Configuration.OAuthCredentials.scope, state: "") { [weak self] in
            guard let self = self else { return }
            let results = try? $0.get()
            guard let parameters = results?.parameters else { return }
            let authTokenEntity = AuthTokenEntity(parameters: parameters)
            self.storage.token = authTokenEntity.token
        }
    }
}
