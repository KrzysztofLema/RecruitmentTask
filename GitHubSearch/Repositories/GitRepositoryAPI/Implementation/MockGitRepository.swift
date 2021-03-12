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
        for text: String,
        sortedBy sorting: Sorting? = .numberOfStars
    ) -> AnyPublisher<GitResponse, GitRepositoryAPIError> {
        Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let repositories: GitResponse =
                    GitResponse(items: [
                        GitRepository(
                            id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                            owner: Owner(avatar: URL(string: ""))),
                        GitRepository(
                            id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                            owner: Owner(avatar: URL(string: ""))),
                        GitRepository(
                            id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                            owner: Owner(avatar: URL(string: "")))
                    ])
                
                promise(.success(repositories))}
        }.eraseToAnyPublisher()
    }
}
