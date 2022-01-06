//
//  AuthTokenEntity.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

struct AuthTokenEntity: Decodable {
    let token: String?
    
    init(parameters: [String: Any]) {
        self.token = parameters["access_token"] as? String
    }
}
