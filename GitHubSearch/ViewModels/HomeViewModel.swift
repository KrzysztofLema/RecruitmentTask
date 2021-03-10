//
//  HomeViewModel.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
class HomeViewModel {
    
    init(gitRepositoryApi: GitRepositoryAPI) {
        self.gitRepositoryApi = gitRepositoryApi
    }
    
    let gitRepositoryApi: GitRepositoryAPI
}
