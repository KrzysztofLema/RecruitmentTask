//
//  SceneDelegate.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appDependencyContainer = AppDependencyContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appDependencyContainer.makeMainViewControllerFactory()
        window.makeKeyAndVisible()
        self.window = window
        
    }
}

