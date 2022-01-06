//
//  Configuration.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

struct Configuration {
    
    struct OAuthCredentials {
        static let clientID = "5ca316f94494b33df608"
        static let clientSecret = "6b7dcd06744331d45b1202d23d98c4e5ed9d30f9"
        static let authorizeUrl = "https://github.com/login/oauth/authorize"
        static let accessTokenUrl = "https://github.com/login/oauth/access_token"
        static let token = "token"
        static let urlScheme = "ATGitHub://oauth-callback"
        static let scope = "repo,gist"
    }
    
    struct URLs {
        static let api = "api.github.com"
    }
}
