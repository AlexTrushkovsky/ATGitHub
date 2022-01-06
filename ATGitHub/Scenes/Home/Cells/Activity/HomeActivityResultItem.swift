//
//  HomeActivityResultItem.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 06.01.2022.
//

import Foundation

struct HomeActivityResultItem: Codable {
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

extension HomeActivityResultItem {
    init(event: Event) {
        self.url = event.repo?.htmlURL ?? ""
        self.name = event.repo?.name ?? ""
        self.imageUrl = event.actor?.avatarURL.flatMap { $0 }
        self.stars = event.repo?.starCount ?? 0
        self.author = event.actor?.login ?? ""
    }
}
