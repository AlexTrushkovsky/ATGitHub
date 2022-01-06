//
//  RepositoriesSearchResult.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

struct RepositoriesSearchResult: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [RepositoryEntity]?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
        case message
    }
}
