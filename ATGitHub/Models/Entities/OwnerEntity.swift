//
//  OwnerEntity.swift
//  ATGitHub
//
//  Created by Алексей Трушковский on 03.01.2022.
//

import Foundation

struct Owner: Codable {
    let avatarURL: String?
    let login: String?
    let company: String?
    let eventsURL: String?

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case login = "login"
        case company = "company"
        case eventsURL = "received_events_url"
    }
}
