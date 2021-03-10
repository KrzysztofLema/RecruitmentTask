//
//  MainViewModel.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
class MainViewModel {
    
    @Published var viewToPresent: ViewToPresent = .splashScreen
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewToPresent = .mainView
        }
    }
}

enum ViewToPresent {
    case splashScreen
    case mainView
}
