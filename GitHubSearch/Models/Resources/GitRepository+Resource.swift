//
//  Repository.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation

enum Resources {}

extension Resources {
    
    struct GitResponse: Codable {
        var totalCount: Int
        var incompleteResults: Bool
        var items: [GitRepository]?
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case incompleteResults = "incomplete_results"
        }
    }
    
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



extension Domain.GitRepository {
    init(from resources: Resources.GitRepository) {
        id = resources.id
        name = resources.name
        url = resources.url
        avatarURL = resources.avatarURL
    }
}
