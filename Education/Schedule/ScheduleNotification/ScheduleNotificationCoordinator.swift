//
//  ScheduleNotificationCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import UIKit

class ScheduleNotificationCoordinator: NSObject, Coordinator, ShowingFocusSelection, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()

    private let subjectName: String
    private let startTime: Date
    private let endTime: Date

    private let blockingManager: BlockingManager

    init(navigationController: UINavigationController, subjectName: String, startTime: Date, endTime: Date, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.subjectName = subjectName
        self.startTime = startTime
        self.endTime = endTime
        self.blockingManager = blockingManager
    }

    func start() {
        let viewModel = ScheduleNotificationViewModel(subjectName: subjectName, startTime: startTime, endTime: endTime)
        let viewController = ScheduleNotificationViewController(color: .red, viewModel: viewModel)
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

extension ScheduleNotificationCoordinator: UINavigationControllerDelegate {
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
