//
//  AppDependencyContainer.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

class AppDependencyContainer {
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
}

extension AppDependencyContainer: HomeViewFactory {
    func makeHomeViewControllerFactory() -> HomeViewController {
        return HomeViewController()
    }
}

typealias MainViewFactories = HomeViewFactory & SplashScreenFactory

protocol MainViewFactory {
    func makeMainViewControllerFactory() -> MainViewController
    func makeMainViewModel() -> MainViewModel
}

extension AppDependencyContainer: MainViewFactory {
    func makeMainViewControllerFactory() -> MainViewController {
        return MainViewController(viewModel: makeMainViewModel())
    }
    
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel()
    }
}

