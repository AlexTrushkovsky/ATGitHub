//
//  EventEntity.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import Foundation

struct Event: Codable {
    let type: String?
    let actor: Owner?
    let repo: RepositoryEntity?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case actor = "actor"
        case repo = "repo"
    }
}
