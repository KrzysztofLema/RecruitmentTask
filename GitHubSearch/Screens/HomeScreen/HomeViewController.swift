//
//  HomeViewController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//


import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = HomeView()
    }
}
