//
//  SearchResultItem.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

struct SearchResultItem: Codable {
    let id: Int
    let url: String
    let name: String
    let imageUrl: String?
    let stars: Int
    let author: String
    
    init() {
        self.id = 0
        self.url = ""
        self.name = ""
        self.imageUrl = ""
        self.stars = 0
        self.author = ""
    }
}

extension SearchResultItem {
    init(repo: RepositoryEntity) {
        self.id = repo.id
        self.url = repo.htmlURL ?? ""
        self.name = repo.name ?? ""
        self.imageUrl = repo.owner?.avatarURL.flatMap { $0 }
        self.stars = repo.starCount ?? 0
        self.author = repo.owner?.login ?? ""
    }
}
