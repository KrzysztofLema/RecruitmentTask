//
//  MainViewModel.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
class MainViewModel {
    
    @Published var viewToPresent: ViewToPresent = .splashScreen
    
    init(mainViewFactories: MainViewFactories) {
        self.mainViewFactories = mainViewFactories
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewToPresent = .mainView
        }
    }
    
    let mainViewFactories: MainViewFactories
}

enum ViewToPresent {
    case splashScreen
    case mainView
}
