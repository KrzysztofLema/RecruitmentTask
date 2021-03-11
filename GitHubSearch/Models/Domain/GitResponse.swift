//
//  GitResponse.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation
extension Domain {
    struct GitResponse {
        var totalCount: Int
        var incompleteResults: Bool
        let items: [Domain.GitRepository]
    }
}
