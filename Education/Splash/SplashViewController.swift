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
        
        let waitingTime: CGFloat = UserDefaults.isFirstEntry ? 6 : 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitingTime) { [weak self] in
            guard let self = self else { return }
            
            if UserDefaults.isFirstEntry {
                UserDefaults.isFirstEntry = false
            }
            
            self.coordinator?.showTabBar()
        }
    }
}
