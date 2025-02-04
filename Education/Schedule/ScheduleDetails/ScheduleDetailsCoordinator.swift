//
//  ScheduleDetailsCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class ScheduleDetailsCoordinator: Coordinator, Dismissing {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let blockingManager: BlockingManager
    private let notificationService: NotificationServiceProtocol?

    private let schedule: Schedule?
    private let selectedDay: Int?

    init(navigationController: UINavigationController, blockingManager: BlockingManager, notificationService: NotificationServiceProtocol?, schedule: Schedule?, selectedDay: Int?) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
        self.notificationService = notificationService
        self.schedule = schedule
        self.selectedDay = selectedDay
    }

    func start() {
        let viewModel = ScheduleDetailsViewModel(notificationService: notificationService, schedule: schedule, selectedDay: selectedDay)
        let viewController = ScheduleDetailsViewController(viewModel: viewModel, blockingManager: blockingManager)
        viewController.coordinator = self

        let newNavigationController = UINavigationController(rootViewController: viewController)
        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            newNavigationController.transitioningDelegate = scheduleCoordinator
        }
        
        newNavigationController.setNavigationBarHidden(true, animated: false)

        newNavigationController.modalPresentationStyle = .pageSheet
        navigationController.present(newNavigationController, animated: true)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
