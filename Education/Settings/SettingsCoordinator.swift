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
    
    private let blockingManager: BlockingManager
    
    init(navigationController: UINavigationController, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
    }
    
    func start() {
        let viewModel = SettingsViewModel()
        let vc = SettingsViewController(viewModel: viewModel, blockingManger: blockingManager)
        vc.coordinator = self
        
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.pushViewController(vc, animated: false)
    }
}
