//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    private var themeList = ThemeListCoordinator(navigationController: UINavigationController())
    private var timer = TimerSettingsCoordinator(navigationController: UINavigationController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeList.start()
        timer.start()
        
        self.viewControllers = [themeList.navigationController, timer.navigationController]
        
        self.view.backgroundColor = .systemBackground
    }
}

