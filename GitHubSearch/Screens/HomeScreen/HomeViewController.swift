//
//  HomeViewController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import UIKit
import Combine
class HomeViewController: UINavigationController {
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func loadView() {
        view = HomeView(viewModel: viewModel)
    }
    
    private let viewModel: HomeViewModel
    private var subscription = Set<AnyCancellable>()
}

private extension HomeViewController {
    func bind() {
        viewModel.selectedRepository.sink { _ in
            self.presentingViewController?.navigationController?.pushViewController(WebScreenViewController(), animated: true)
        }.store(in: &subscription)
    }
}
