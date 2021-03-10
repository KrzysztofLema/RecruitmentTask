//
//  GitRepository.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation

enum Domain {}

extension Domain {
    struct GitRepository {
        var id: Int?
        var name: String?
        var url: URL?
        var avatarURL: URL?
    }
}
