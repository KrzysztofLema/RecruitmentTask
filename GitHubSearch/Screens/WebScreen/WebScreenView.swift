//
//  WebScreenView.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation
import UIKit
import WebKit

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
    
    override init(frame: CGRect = .zero) {
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
        let myURL = URL(string:"https://www.apple.com")!
        webView.load(URLRequest(url: myURL))
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
}

private extension WebScreenView {
    func bind() {
        
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
