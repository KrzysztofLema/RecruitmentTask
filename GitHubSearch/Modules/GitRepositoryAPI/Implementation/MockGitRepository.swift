//
//  MockGitRepository.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
import Combine

class MockGitRepository: GitRepositoryAPI {
    
    init() {}
    
    func getRepositorySearchResult(
        for text: String
    ) -> AnyPublisher<[Domain.GitRepository], GitRepositoryAPIError> {
        Future { promise in
            let repositories: [Domain.GitRepository] = [
                Domain.GitRepository(id: 0, name: "asd", url: URL(string: ""), avatarURL: URL(string: "")),
                Domain.GitRepository(id: 1, name: "asd", url: URL(string: ""), avatarURL: URL(string: "")),
                Domain.GitRepository(id: 2, name: "asd", url: URL(string: ""), avatarURL: URL(string: ""))
            ]
            promise(.success(repositories))
        }.eraseToAnyPublisher()
    }
}
