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
        var items: [GitRepository]?
    }
    
    struct GitRepository: Codable {
        var id: Int?
        var name: String?
        var url: URL?
        var description: String?
        var owner: Owner

        enum CodingKeys: String, CodingKey {
            case url = "html_url"
            case id = "id"
            case name = "name"
            case description = "description"
            case owner = "owner"
        }
    }
    
    struct Owner: Codable {
        
        var avatar: URL?
        
        enum CodingKeys: String, CodingKey {
            case avatar = "avatar_url"
        }
    }
}
