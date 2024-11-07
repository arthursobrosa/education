//
//  ScheduleDetailsCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class ScheduleDetailsCoordinator: NSObject, Coordinator, Dismissing, ShowingSubjectCreation {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

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
        let viewController = ScheduleDetailsViewController(viewModel: viewModel)
        viewController.coordinator = self

        let newNavigationController = UINavigationController(rootViewController: viewController)
        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            newNavigationController.transitioningDelegate = scheduleCoordinator
        }

        newNavigationController.modalPresentationStyle = .pageSheet
        navigationController.present(newNavigationController, animated: true)
    }
    
    func showSubjectCreation(viewModel: StudyTimeViewModel) {
        let child = SubjectCreationCoordinator(navigationController: navigationController, viewModel: viewModel)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
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

extension ScheduleDetailsCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let nav = dismissed as? UINavigationController else { return nil }
        
        if let subjectCreationVC = nav.viewControllers.first as? SubjectCreationViewController {
            childDidFinish(subjectCreationVC.coordinator as? Coordinator)

            if let scheduleDetailsVC = navigationController.viewControllers.first as? ScheduleDetailsViewController {
                scheduleDetailsVC.reloadTable()
            }
        }

        return nil
    }
}
