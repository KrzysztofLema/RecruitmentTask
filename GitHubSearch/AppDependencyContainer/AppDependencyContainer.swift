//
//  AppDependencyContainer.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//
import Foundation

class AppDependencyContainer {
    
    lazy var gitRepositoryAPI: GitRepositoryAPI = {
        makeGitRepositoryAPI()
    }()
    
    init() {}
}

protocol SplashScreenFactory {
    func makeSplashScreenViewController() -> SplashScreenViewController
}

extension AppDependencyContainer: SplashScreenFactory {
    func makeSplashScreenViewController() -> SplashScreenViewController {
        return SplashScreenViewController()
    }
}

protocol HomeViewFactory {
    func makeHomeViewControllerFactory() -> HomeViewController
    func makeHomeViewModelFactory() -> HomeViewModel
}

extension AppDependencyContainer: HomeViewFactory {
    func makeHomeViewModelFactory() -> HomeViewModel {
        return HomeViewModel(gitRepositoryApi: gitRepositoryAPI)
    }
    
    func makeHomeViewControllerFactory() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModelFactory(), viewFactories: self)
    }
}

typealias ViewFactories = HomeViewFactory & SplashScreenFactory & WebViewFactory

protocol MainViewFactory {
    func makeMainViewControllerFactory() -> MainViewController
    func makeMainViewModel() -> MainViewModel
}

extension AppDependencyContainer: MainViewFactory {
    func makeMainViewControllerFactory() -> MainViewController {
        return MainViewController(viewModel: makeMainViewModel())
    }
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(mainViewFactories: self)
    }
}

protocol WebViewFactory {
    func makeWebViewController(webURL: URL) -> WebScreenViewController 
    func makeWebScreenViewModel(webURL: URL) -> WebScreenViewModel
}

extension AppDependencyContainer: WebViewFactory {
    func makeWebViewController(webURL: URL) -> WebScreenViewController {
        return WebScreenViewController(viewModel: makeWebScreenViewModel(webURL: webURL))
    }
    
    func makeWebScreenViewModel(webURL: URL) -> WebScreenViewModel {
        return WebScreenViewModel(webURL: webURL)
    }
}

protocol GitRepositoryAPIFactory {
    func makeGitRepositoryAPI() -> GitRepositoryAPI
}

extension AppDependencyContainer: GitRepositoryAPIFactory {
    func makeGitRepositoryAPI() -> GitRepositoryAPI {
        return GitRepositoryApiImpl()
    }
}
