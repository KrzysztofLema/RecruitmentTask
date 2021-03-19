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
    @Published private(set) var gitRepositoryResults: [GitRepository] = []
    @Published var homeViewState: HomeViewState = .defaultState
    
    let selectedRepository = PassthroughSubject<GitRepository, Never>()
    let apiError = PassthroughSubject<GitRepositoryAPIError, Never>()
    var webScreenViewController: WebScreenViewController?
    
    init() {
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
    
    private var subscriptions = Set<AnyCancellable>()
}

private extension HomeViewModel {
    func searchForGitRepositories(with searchInput: String) {
        
    }
}

enum HomeViewState {
    case isLoadingData
    case loadedData
    case defaultState
}
