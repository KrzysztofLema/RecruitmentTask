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
        viewModel.selectedRepository.sink { [weak self] url in
            guard let self = self else { return }
            let webViewController = self.viewFactories.makeWebViewController(webURL: url)
            self.navigationController?.pushViewController(webViewController, animated: true)
        }.store(in: &subscription)
    }
}
