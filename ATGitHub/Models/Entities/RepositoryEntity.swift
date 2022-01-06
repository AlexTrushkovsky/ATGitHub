//
//  RepositoryEntity.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

struct RepositoryEntity: Codable {
    let id: Int
    let name: String?
    let owner: Owner?
    let htmlURL: String?
    let starCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, owner
        case name = "name"
        case starCount = "stargazers_count"
        case htmlURL = "html_url"
    }
}
