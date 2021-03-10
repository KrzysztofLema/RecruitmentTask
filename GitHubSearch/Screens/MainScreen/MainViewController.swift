//
//  MainViewController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
import UIKit
import Combine

class MainViewController: UIViewController {
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
    }
    
    func present(_ view: ViewToPresent) {
        switch view {
        case .splashScreen:
            addFullScreen(viewModel.mainViewFactories.makeSplashScreenViewController())
        case .mainView:
            addFullScreen(viewModel.mainViewFactories.makeHomeViewControllerFactory())
        }
    }
    
    private let viewModel: MainViewModel
}

private extension MainViewController {
    func addFullScreen(_ childViewController: UIViewController) {
        guard childViewController.parent == nil else {
            return
        }
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            childViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        childViewController.didMove(toParent: self)
    }
}
