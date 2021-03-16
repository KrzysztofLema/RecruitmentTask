//
//  RepositoryTableViewCell.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 12/03/2021.
//

import UIKit
import Kingfisher
class RepositoryTableViewCell: UITableViewCell {
    
    var hierarchyNotReady = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with gitRepository: GitRepository) {
        titleLabel.text = gitRepository.name
        descriptionLabel.text = gitRepository.descriptionOfRepo
        let url = gitRepository.owner.avatar
        imageView?.kf.setImage(with: url, placeholder: nil, options: nil, completionHandler: { _ in
            self.setNeedsLayout()
        })
    }
    
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
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

private extension RepositoryTableViewCell {
    
    func constructHierarchy() {
        addSubview(avatarImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    func activateConstraints() {
        activateAvatarImageViewConstraints()
        activateTitleLabelConstraints()
        activateDescriptionLabel()
    }
    
    func activateAvatarImageViewConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func activateTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func activateDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
