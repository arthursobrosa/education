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
    private var newNavigationController = UINavigationController()
    
    private let notificationService: NotificationServiceProtocol?
    
    private let schedule: Schedule?
    private let selectedDay: Int?
    
    init(navigationController: UINavigationController, notificationService: NotificationServiceProtocol?, schedule: Schedule?, selectedDay: Int?) {
        self.navigationController = navigationController
        self.notificationService = notificationService
        self.schedule = schedule
        self.selectedDay = selectedDay
    }
    
    func start() {
        let viewModel = ScheduleDetailsViewModel(notificationService: notificationService, schedule: schedule, selectedDay: selectedDay)
        let vc = ScheduleDetailsViewController(viewModel: viewModel)
        vc.coordinator = self
        
        newNavigationController = UINavigationController(rootViewController: vc)
        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            newNavigationController.transitioningDelegate = scheduleCoordinator
        }
        
        newNavigationController.modalPresentationStyle = .pageSheet
        navigationController.present(newNavigationController, animated: true)
    }
    
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
