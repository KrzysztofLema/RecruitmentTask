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
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    private let viewModel: WebScreenViewModel
    private var subscriptions = Set<AnyCancellable>()
}

private extension WebScreenView {
    func bind() {
        viewModel.$gitRepository
            .sink { [weak self] gitRepository in
                guard let self = self, let url = gitRepository?.url else { return }
                let urlRequest = URLRequest(url: url)
                self.repositoryDetailWebView.load(urlRequest)
            }.store(in: &subscriptions)
        
        viewModel.$viewState
            .sink { [weak self] state in
                switch state {
                case .isLoading:
                    self?.loadingIndicator.startAnimating()
                case .loaded:
                    self?.loadingIndicator.stopAnimating()
                }
            }.store(in: &subscriptions)
    }
    
    func constructHierarchy() {
        addSubview(repositoryDetailWebView)
        repositoryDetailWebView.addSubview(loadingIndicator)
    }
    
    func activateConstraints() {
        activateRepositoryDetailWebView()
        activateLoadingIndicatorConstraints()
    }
    
    func activateRepositoryDetailWebView() {
        NSLayoutConstraint.activate([
            repositoryDetailWebView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            repositoryDetailWebView.leftAnchor.constraint(equalTo: leftAnchor),
            repositoryDetailWebView.rightAnchor.constraint(equalTo: rightAnchor),
            repositoryDetailWebView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func activateLoadingIndicatorConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: repositoryDetailWebView.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: repositoryDetailWebView.centerXAnchor)
        ])
    }
}

extension WebScreenView: WKUIDelegate {}
extension WebScreenView: WKNavigationDelegate {
    //swiftlint:disable implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.viewState = .loaded
    }
}
