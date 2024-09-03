//
//  SettingsCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SettingsViewModel()
        let vc = SettingsViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.pushViewController(vc, animated: false)
    }
}
