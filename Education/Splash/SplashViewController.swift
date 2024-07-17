//
//  SplashViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/07/24.
//

import UIKit

class SplashViewController: UIViewController {
    weak var coordinator: ShowingTabBar?
    
    private let splashView = SplashView()
    
    override func loadView() {
        super.loadView()
        
        self.view = self.splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            
            self.coordinator?.showTabBar()
        }
    }
}
