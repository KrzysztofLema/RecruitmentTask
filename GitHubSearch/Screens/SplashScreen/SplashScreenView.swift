//
//  SplashScreenView.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import UIKit

class SplashScreenView: UIView {
    
    var hierarchyNotReady = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = .systemBlue
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    
    private lazy var appNameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Git Hub Search"
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var appImageView: UIImageView = {
        let image = UIImage(named: "github-logo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var appLogoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appNameTextLabel, appImageView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
}
private extension SplashScreenView {
    func constructHierarchy() {
        addSubview(appLogoStackView)
    }
    
    func activateConstraints() {
        activateAppLogoStackViewConstraints()
    }
    
    func activateAppLogoStackViewConstraints() {
        NSLayoutConstraint.activate([
            appLogoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            appLogoStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
