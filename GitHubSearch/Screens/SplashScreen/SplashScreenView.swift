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
        backgroundColor = .red
        hierarchyNotReady = false
    }
    
}
