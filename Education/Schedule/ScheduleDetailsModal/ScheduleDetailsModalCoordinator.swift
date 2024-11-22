//
//  ScheduleDetailsModalCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 15/08/24.
//

import UIKit

class ScheduleDetailsModalCoordinator: NSObject, Coordinator, ShowingFocusSelection, Dismissing, ShowingScheduleDetails {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()

    private let blockingManager: BlockingManager
    private let schedule: Schedule

    init(navigationController: UINavigationController, blockingManager: BlockingManager, schedule: Schedule) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
        self.schedule = schedule
    }

    func start() {
        let viewModel = ScheduleDetailsModalViewModel(schedule: schedule)
        let viewController = ScheduleDetailsModalViewController(viewModel: viewModel)
        viewController.coordinator = self

        newNavigationController = UINavigationController(rootViewController: viewController)

        newNavigationController.delegate = self
        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            newNavigationController.transitioningDelegate = scheduleCoordinator
        }

        newNavigationController.setNavigationBarHidden(true, animated: false)

        newNavigationController.modalPresentationStyle = .overFullScreen
        newNavigationController.modalTransitionStyle = .crossDissolve

        navigationController.present(newNavigationController, animated: true)
    }

    func showFocusSelection(focusSessionModel: FocusSessionModel) {
        let child = FocusSelectionCoordinator(navigationController: newNavigationController, isFirstModal: false, focusSessionModel: focusSessionModel, blockingManager: blockingManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showScheduleDetails(schedule: Schedule?, selectedDay: Int?) {
        dismiss(animated: false)

        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            scheduleCoordinator.showScheduleDetails(schedule: schedule, selectedDay: selectedDay)
        }
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

extension ScheduleDetailsModalCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromVC) {
            return
        }

        if let focusSelectionVC = fromVC as? FocusSelectionViewController {
            childDidFinish(focusSelectionVC.coordinator as? Coordinator)
        }
    }
}
