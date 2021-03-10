//
//  GitRepositoryApi.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
import Combine
protocol GitRepositoryAPI {
    func getRepositorySearchResult(for text: String) -> AnyPublisher<[Domain.GitRepository], GitRepositoryAPIError>
}

enum GitRepositoryAPIError: Error {
    case decoding
    case notHTTPResponse
    case badHTTPResponse(statusCode: Int)
}
