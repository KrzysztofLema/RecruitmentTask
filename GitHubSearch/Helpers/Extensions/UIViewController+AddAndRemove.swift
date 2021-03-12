//
//  UIViewController+.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 12/03/2021.
//

import UIKit
extension UIViewController {
    func addFullScreen(_ childViewController: UIViewController) {
        guard childViewController.parent == nil else {
            return
        }
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            childViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        childViewController.didMove(toParent: self)
    }
    
    func remove(_ childViewController: UIViewController?){
        guard let child = childViewController, child.parent != nil else {
            return
        }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
