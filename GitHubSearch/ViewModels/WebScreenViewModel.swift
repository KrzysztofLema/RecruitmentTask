//
//  WebScreenViewModel.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation

class WebScreenViewModel {
    
    @Published var webURL: URL?
    
    init(webURL: URL) {
        self.webURL = webURL
    }
    
}
