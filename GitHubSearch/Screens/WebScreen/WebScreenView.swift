//
//  WebScreenView.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation
import UIKit
import WebKit
import Combine

class WebScreenView: UIView {
    var hierarchyNotReady = true
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .white
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    
    init(frame: CGRect = .zero, viewModel: WebScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var repositoryDetailWebView: WKWebView = {
        let webViewConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let viewModel: WebScreenViewModel
    private var subscriptions = Set<AnyCancellable>()
}

private extension WebScreenView {
    func bind() {
        viewModel.$webURL
            .sink { [weak self] url in
                guard let self = self, let url = url else { return }
                let urlRequest = URLRequest(url: url)
                self.repositoryDetailWebView.load(urlRequest)
            }.store(in: &subscriptions)
    }
    
    func constructHierarchy() {
        addSubview(repositoryDetailWebView)
    }
    
    func activateConstraints() {
        activateRepositoryDetailWebView()
    }
    
    func activateRepositoryDetailWebView() {
        NSLayoutConstraint.activate([
            repositoryDetailWebView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            repositoryDetailWebView.leftAnchor.constraint(equalTo: leftAnchor),
            repositoryDetailWebView.rightAnchor.constraint(equalTo: rightAnchor),
            repositoryDetailWebView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension WebScreenView: WKUIDelegate {
    
}
