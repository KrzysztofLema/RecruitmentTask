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
    @Published var homeViewState: HomeViewState = .defaultState
    
    let selectedRepository = PassthroughSubject<Resources.GitRepository, Never>()
    let apiError = PassthroughSubject<GitRepositoryAPIError, Never>()
    var webScreenViewController: WebScreenViewController?
    
    init(gitRepositoryApi: GitRepositoryAPI) {
        self.gitRepositoryApi = gitRepositoryApi
        bind()
    }
    
    func bind() {
        $searchInput
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] searchValue in
            guard let self = self else { return }
            self.homeViewState = .isLoadingData
            self.searchForGitRepositories(with: searchValue)
        }.store(in: &subscriptions)
        
        $searchInput
            .filter { $0.isEmpty }
            .sink { _ in
                self.homeViewState = .defaultState
                self.gitRepositoryResults = []
            }
            .store(in: &subscriptions)
    }
    
    private let gitRepositoryApi: GitRepositoryAPI
    private var subscriptions = Set<AnyCancellable>()
}

private extension HomeViewModel {
    func searchForGitRepositories(with searchInput: String) {
        gitRepositoryApi
            .getRepositorySearchResult(for: searchInput, sortedBy: .numberOfStars)
            .sink { error in
                if case .failure(let error) = error {
                    self.apiError.send(error)
                }
            } receiveValue: { searchResult in
                guard let searchResult = searchResult.items else { return }
                self.homeViewState = .loadedData
                self.gitRepositoryResults = searchResult
            }.store(in: &subscriptions)
    }
}

enum HomeViewState {
    case isLoadingData
    case loadedData
    case defaultState
}
