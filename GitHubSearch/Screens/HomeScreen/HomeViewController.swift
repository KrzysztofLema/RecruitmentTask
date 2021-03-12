//
//  HomeViewController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import UIKit
import Combine
class HomeViewController: UIViewController {
    
    init(viewModel: HomeViewModel, viewFactories: ViewFactories) {
        self.viewModel = viewModel
        self.viewFactories = viewFactories
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Git Search"
        bind()
    }
    
    override func loadView() {
        view = HomeView(viewModel: viewModel)
    }
    
    private let viewFactories: ViewFactories
    private let viewModel: HomeViewModel
    private var subscription = Set<AnyCancellable>()
}

private extension HomeViewController {
    func bind() {
        viewModel.selectedRepository
            .sink { [weak self] gitRepository in
                guard let self = self else { return }
                let webViewController = self.viewFactories.makeWebViewController(gitRepository: gitRepository)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }.store(in: &subscription)
        
        viewModel.apiError
            .receive(on: DispatchQueue.main)
            .sink { error in
                self.presentAlert(with: error)
            }.store(in: &subscription)
    }
}
private extension HomeViewController {
    func presentAlert(with error: GitRepositoryAPIError) {
        let errorAlert = UIAlertController(
            title: error.localizedDescription,
            message: nil,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
}
