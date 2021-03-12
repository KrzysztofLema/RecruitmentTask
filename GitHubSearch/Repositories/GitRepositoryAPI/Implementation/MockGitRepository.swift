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
    ) -> AnyPublisher<Resources.GitResponse, GitRepositoryAPIError> {
        Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let repositories: Resources.GitResponse =
                    Resources.GitResponse(items: [
                        Resources.GitRepository(
                            id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                            owner: Resources.Owner(avatar: URL(string: ""))),
                        Resources.GitRepository(
                            id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                            owner: Resources.Owner(avatar: URL(string: ""))),
                        Resources.GitRepository(
                            id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                            owner: Resources.Owner(avatar: URL(string: "")))
                    ])
                
                promise(.success(repositories))}
        }.eraseToAnyPublisher()
    }
}
