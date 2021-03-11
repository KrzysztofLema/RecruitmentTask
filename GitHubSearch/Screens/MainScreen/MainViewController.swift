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
    
    let splashScreenViewController: SplashScreenViewController
    let homeViewController: HomeViewController
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        splashScreenViewController = viewModel.mainViewFactories.makeSplashScreenViewController()
        homeViewController = viewModel.mainViewFactories.makeHomeViewControllerFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        bind()
    }
    
    func present(_ view: ViewToPresent) {
        switch view {
        case .splashScreen:
            addFullScreen(splashScreenViewController)
        case .mainView:
            addFullScreen(homeViewController)
        }
    }
    
    private let viewModel: MainViewModel
    private var subscriptions = Set<AnyCancellable>()
}

private extension MainViewController {
    
    func presentSplashScreen() {
        addFullScreen(splashScreenViewController)
    }
    
    func presentHomeView() {
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true) { [weak self] in
            guard let self = self else { return }
            self.remove(self.splashScreenViewController)
        }
    }
    
    func subscribe(to publisher: AnyPublisher<ViewToPresent, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewToPresent in
                guard let self = self else { return }
                self.present(viewToPresent)
            }.store(in: &subscriptions)
    }
    
    func bind() {
        let publisher = viewModel.$viewToPresent.removeDuplicates().eraseToAnyPublisher()
        subscribe(to: publisher)
    }
    
}

extension MainViewController {
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
    
    func remove(_ childViewController: UIViewController?){
        guard let child = childViewController, child.parent != nil else {
            return
        }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
