//
//  FocusSessionCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class FocusSessionCoordinator: NSObject, Coordinator, ShowingFocusEnd, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()

    private let activityManager: ActivityManager
    private let blockingManager: BlockingManager

    init(navigationController: UINavigationController, activityManager: ActivityManager, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.activityManager = activityManager
        self.blockingManager = blockingManager
    }

    func start() {
        let viewModel = FocusSessionViewModel(activityManager: activityManager, blockingManager: blockingManager)
        let vc = FocusSessionViewController(viewModel: viewModel, color: activityManager.color)
        vc.coordinator = self

        newNavigationController = UINavigationController(rootViewController: vc)

        if let delegateCoordinator = getTransitioningDelegate() as? UIViewControllerTransitioningDelegate {
            newNavigationController.transitioningDelegate = delegateCoordinator
        }

        newNavigationController.modalPresentationStyle = .fullScreen

        // This will cause the status bar to be hidden
        newNavigationController.setNavigationBarHidden(true, animated: false)

        navigationController.present(newNavigationController, animated: true)
    }

    private func getTransitioningDelegate() -> Coordinator? {
        var delegateCoordinator: Coordinator?

        if let focusPickerCoordinator = parentCoordinator as? FocusPickerCoordinator {
            delegateCoordinator = focusPickerCoordinator

            focusPickerCoordinator.dismissAll()
        } else if let focusSelectionCoordinator = parentCoordinator as? FocusSelectionCoordinator {
            if let focusImediateCoordinator = focusSelectionCoordinator.parentCoordinator as? FocusImediateCoordinator,
               let scheduleCoordinator = focusImediateCoordinator.parentCoordinator as? ScheduleCoordinator
            {
                delegateCoordinator = scheduleCoordinator
            } else if let scheduleCoordinator = focusSelectionCoordinator.parentCoordinator as? ScheduleCoordinator {
                delegateCoordinator = scheduleCoordinator
            }

            focusSelectionCoordinator.dismissAll()
        } else if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            delegateCoordinator = scheduleCoordinator
        }

        return delegateCoordinator
    }

    func showFocusEnd(activityManager: ActivityManager) {
        newNavigationController.delegate = self
        let child = FocusEndCoordinator(navigationController: newNavigationController, activityManager: activityManager)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension FocusSessionCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromVC) {
            return
        }

        if let focusEndVC = fromVC as? FocusEndViewController {
            childDidFinish(focusEndVC.coordinator as? Coordinator)
        }
    }
}
