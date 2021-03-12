//
//  GitRepositoryApi.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
import Combine
protocol GitRepositoryAPI {
    func getRepositorySearchResult(
        for text: String,
        sortedBy sorting: Sorting?
    ) -> AnyPublisher<GitResponse, GitRepositoryAPIError>
}

enum GitRepositoryAPIError: Error {
    case unknown
    case wrongURL
    case decoding
    case notHTTPResponse
    case badHTTPResponse(statusCode: Int)
}

enum Sorting: String {
    case numberOfStars = "stars"
    case numberOfForks = "forks"
    case recency = "updated"
}
