//
//  MockTestGitRepositoryAPI.swift
//  GitHubSearchTests
//
//  Created by Krzysztof Lema on 12/03/2021.
//

import Foundation
import Combine
@testable import GitHubSearch

class MockTestGitRepositoryApi: GitRepositoryAPI {
    
    var futureResult: Future<Resources.GitResponse, GitRepositoryAPIError>!
    
    func getRepositorySearchResult(for text: String, sortedBy sorting: Sorting?) -> AnyPublisher<Resources.GitResponse, GitRepositoryAPIError> {
        futureResult.eraseToAnyPublisher()
    }
}
