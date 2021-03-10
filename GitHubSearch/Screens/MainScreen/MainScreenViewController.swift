//
//  MainScreenViewController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//


import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = MainScreenView()
    }
}
