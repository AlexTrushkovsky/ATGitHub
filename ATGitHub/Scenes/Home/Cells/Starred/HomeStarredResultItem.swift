//
//  HomeStarredResultItem.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import Foundation

struct HomeStarredResultItem: Codable {
    let url: String
    let name: String?
    let imageUrl: String?
    let stars: Int
    let author: String
    
    init() {
        self.url = ""
        self.name = ""
        self.imageUrl = ""
        self.stars = 0
        self.author = ""
    }
}

extension HomeStarredResultItem {
    init(starredRepo: RepositoryEntity) {
        self.url = starredRepo.htmlURL ?? ""
        self.name = starredRepo.name ?? ""
        self.imageUrl = starredRepo.owner?.avatarURL.flatMap { $0 }
        self.stars = starredRepo.starCount ?? 0
        self.author = starredRepo.owner?.login ?? ""
    }
}
