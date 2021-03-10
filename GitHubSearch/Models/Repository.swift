//
//  Repository.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation

struct GitRepository: Codable {
    var id: Int?
    var name: String?
    var url: URL?

    enum CodingKeys: String, CodingKey {
       case url = "html_url"
    }
}
