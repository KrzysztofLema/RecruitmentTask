//
//  WebScreenViewModel.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation

class WebScreenViewModel {
    
    @Published var gitRepository: Resources.GitRepository?
    @Published var viewState: WebViewState = .isLoading
    
    init(gitRepository: Resources.GitRepository) {
        self.gitRepository = gitRepository
        
    }
    
    enum WebViewState {
        case isLoading
        case loaded
    }
}
