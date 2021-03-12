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
            presentSplashScreen()
        case .mainView:
            presentHomeView()
        }
    }
    
    private let splashScreenViewController: SplashScreenViewController
    private let homeViewController: HomeViewController
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
        present(navigationController, animated: true) { [weak self] in
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
