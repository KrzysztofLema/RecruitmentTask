//
//  HomeViewModel.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
import Combine
class HomeViewModel {
    
    @Published var searchInput: String = ""
    @Published private(set) var gitRepositoryResults: [Resources.GitRepository] = []
    let selectedRepository = PassthroughSubject<URL, Never>()
    var webScreenViewController: WebScreenViewController?
    
    init(gitRepositoryApi: GitRepositoryAPI) {
        self.gitRepositoryApi = gitRepositoryApi
        bind()
    }
    
    func bind() {
        $searchInput
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { [weak self] searchValue in
            guard let self = self else { return }
            self.searchForGitRepositories(with: searchValue)
        }.store(in: &subscriptions)
    }
    
    private let gitRepositoryApi: GitRepositoryAPI
    private var subscriptions = Set<AnyCancellable>()
}

private extension HomeViewModel {
    func searchForGitRepositories(with searchInput: String) {
        gitRepositoryApi
            .getRepositorySearchResult(for: searchInput)
            .sink { error in
                print(error)
            } receiveValue: { searchResult in
                guard let searchResult = searchResult.items else { return }
                self.gitRepositoryResults = searchResult
            }.store(in: &subscriptions)
    }
}
