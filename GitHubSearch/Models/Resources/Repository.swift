//
//  Repository.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation

enum Resources {}

extension Resources {
    struct GitRepository: Codable {
        var id: Int?
        var name: String?
        var url: URL?
        var avatarURL: URL?
        
        enum CodingKeys: String, CodingKey {
            case url = "html_url"
            case avatarURL = "avatar_url"
        }
    }
}
