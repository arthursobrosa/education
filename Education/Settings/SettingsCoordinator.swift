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
    private let notificationService: NotificationProtocol?
    
    init(navigationController: UINavigationController, blockingManager: BlockingManager, notificationService: NotificationProtocol?) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
        self.notificationService = notificationService
    }
    
    func start() {
        let viewModel = SettingsViewModel(notificationService: notificationService)
        let vc = SettingsViewController(viewModel: viewModel, blockingManger: blockingManager)
        vc.coordinator = self
        
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.pushViewController(vc, animated: false)
    }
}
