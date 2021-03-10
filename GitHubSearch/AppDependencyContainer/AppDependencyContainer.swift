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

protocol MainViewScreenFactory {
    func makeMainViewControllerFactory() -> MainViewController
}

extension AppDependencyContainer: MainViewScreenFactory {
    func makeMainViewControllerFactory() -> MainViewController {
        return MainViewController()
    }
}
