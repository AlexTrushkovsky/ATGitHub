//
//  GitHubAPI.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import UIKit

enum GitHubAPI {
    case search(model: SearchInput)
    case starred(token: String)
    case user(token: String)
    case lastEvents(userName: String)
    case starRepoAction(userName: String, repoName: String, token: String)
}

extension GitHubAPI {

    var domainComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Configuration.URLs.api
        components.path = path
        return components
    }

    var url: URL? {
        var components = domainComponents
        switch self {
        case .search(let input):
            components.queryItems = input.queryItems
        default: break
        }
        return components.url
    }

    var path: String {
        switch self {
        case .search:
            return "/search/repositories"
        case .starred:
            return "/user/starred"
        case .user:
            return "/user"
        case .lastEvents(userName: let userName):
            return "/users/\(userName)/received_events"
        case .starRepoAction(userName: let userName, repoName: let repoName, token: _):
            return "/user/starred/\(userName)/\(repoName)"
        }
    }

    var headers: [String: String]? {
        var internalHeaders: [String: String] = [:]
        switch self {
        case .search(let input):
            internalHeaders["Authorization"] = "Bearer \(input.token)"
            internalHeaders["Accept"] = "application/vnd.github.v3+json"
        case .starred(let token):
            internalHeaders["Authorization"] = "Bearer \(token)"
        case .user(let token):
            internalHeaders["Authorization"] = "Bearer \(token)"
        case .lastEvents(userName: _):
            break
        case .starRepoAction(_, _, let token):
            internalHeaders["Authorization"] = "Bearer \(token)"
        }
        return internalHeaders
    }
}

extension Encodable {
    var encoded: Data? {
        return try? JSONEncoder().encode(self)
    }
}
