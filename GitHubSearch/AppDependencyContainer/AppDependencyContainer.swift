//
//  AppDependencyContainer.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//
import Foundation

typealias ViewFactories = HomeViewFactory & SplashScreenFactory & WebViewFactory

class AppDependencyContainer {
    
    lazy var gitRepositoryAPI: GitRepositoryAPI = {
        makeGitRepositoryAPI()
    }()
    
    init() {}
}

protocol SplashScreenFactory {
    func makeSplashScreenViewController() -> SplashScreenViewController
}

protocol HomeViewFactory {
    func makeHomeViewControllerFactory() -> HomeViewController
    func makeHomeViewModelFactory() -> HomeViewModel
}

extension AppDependencyContainer: SplashScreenFactory {
    func makeSplashScreenViewController() -> SplashScreenViewController {
        return SplashScreenViewController()
    }
}

protocol MainViewFactory {
    func makeMainViewControllerFactory() -> MainViewController
    func makeMainViewModel() -> MainViewModel
}

protocol WebViewFactory {
    func makeWebViewController(gitRepository: Resources.GitRepository) -> WebScreenViewController
    func makeWebScreenViewModel(gitRepository: Resources.GitRepository) -> WebScreenViewModel
}

protocol GitRepositoryAPIFactory {
    func makeGitRepositoryAPI() -> GitRepositoryAPI
}

extension AppDependencyContainer: HomeViewFactory {
    func makeHomeViewModelFactory() -> HomeViewModel {
        return HomeViewModel(gitRepositoryApi: gitRepositoryAPI)
    }
    
    func makeHomeViewControllerFactory() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModelFactory(), viewFactories: self)
    }
}

extension AppDependencyContainer: MainViewFactory {
    func makeMainViewControllerFactory() -> MainViewController {
        return MainViewController(viewModel: makeMainViewModel())
    }
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(mainViewFactories: self)
    }
}

extension AppDependencyContainer: WebViewFactory {
    func makeWebViewController(gitRepository: Resources.GitRepository) -> WebScreenViewController {
        return WebScreenViewController(viewModel: makeWebScreenViewModel(gitRepository: gitRepository))
    }
    
    func makeWebScreenViewModel(gitRepository: Resources.GitRepository) -> WebScreenViewModel {
        return WebScreenViewModel(gitRepository: gitRepository)
    }
}

extension AppDependencyContainer: GitRepositoryAPIFactory {
    func makeGitRepositoryAPI() -> GitRepositoryAPI {
        return GitRepositoryApiImpl()
    }
}
