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
    private let notificationService: NotificationServiceProtocol?

    init(navigationController: UINavigationController, blockingManager: BlockingManager, notificationService: NotificationServiceProtocol?) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
        self.notificationService = notificationService
    }

    func start() {
        let viewModel = SettingsViewModel(notificationService: notificationService)
        let vc = SettingsViewController(viewModel: viewModel, blockingManger: blockingManager)
        vc.coordinator = self

        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(vc, animated: false)
    }
}
