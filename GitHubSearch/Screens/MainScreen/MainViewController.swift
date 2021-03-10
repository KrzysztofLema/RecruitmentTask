//
//  MainViewController.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 10/03/2021.
//

import Foundation
import UIKit
import Combine

class MainViewController: UIViewController {
            
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
    }
    
    func present(_ view: ViewToPresent) {
        switch view {
        case .splashScreen:
            print("SplashSCreen")
        case .mainView:
            print("Main view")
        }
    }
}
