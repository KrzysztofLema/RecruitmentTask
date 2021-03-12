//
//  WebScreenController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation
import UIKit

class WebScreenViewController: UIViewController {
    
    init(viewModel: WebScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.gitRepository?.name
    }
    
    override func loadView() {
        view = WebScreenView(viewModel: viewModel)
    }
    
    private let viewModel: WebScreenViewModel
}
