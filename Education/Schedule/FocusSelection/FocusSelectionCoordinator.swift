//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionCoordinator: NSObject, Coordinator, ShowingFocusPicker, ShowingTimer, Dismissing, DismissingAll {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let isFirstModal: Bool
    private var newNavigationController = UINavigationController()

    private let focusSessionModel: FocusSessionModel
    private let blockingManager: BlockingManager

    init(navigationController: UINavigationController, isFirstModal: Bool, focusSessionModel: FocusSessionModel, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.isFirstModal = isFirstModal
        self.focusSessionModel = focusSessionModel
        self.blockingManager = blockingManager
    }

    func start() {
        let viewModel = FocusSelectionViewModel(focusSessionModel: focusSessionModel)
        let vc = FocusSelectionViewController(viewModel: viewModel, color: focusSessionModel.color)
        vc.coordinator = self

        if isFirstModal {
            newNavigationController = UINavigationController(rootViewController: vc)

            newNavigationController.delegate = self
            if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
                newNavigationController.transitioningDelegate = scheduleCoordinator
            }

            newNavigationController.setNavigationBarHidden(true, animated: false)

            newNavigationController.modalPresentationStyle = .overFullScreen
            newNavigationController.modalTransitionStyle = .crossDissolve

            navigationController.present(newNavigationController, animated: true)

            return
        }

        navigationController.pushViewController(vc, animated: false)
    }

    func showFocusPicker(focusSessionModel: FocusSessionModel) {
        let child = FocusPickerCoordinator(navigationController: isFirstModal ? newNavigationController : navigationController, focusSessionModel: focusSessionModel, blockingManager: blockingManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showTimer(focusSessionModel: FocusSessionModel?) {
        guard let scheduleCoordinator = getParentCoordinator() as? ScheduleCoordinator else { return }

        scheduleCoordinator.showTimer(focusSessionModel: focusSessionModel)
    }

    func getParentCoordinator() -> Coordinator? {
        var parentCoordinator: Coordinator?

        if let focusImediateCoordinator = self.parentCoordinator as? FocusImediateCoordinator,
           let scheduleCoordinator = focusImediateCoordinator.parentCoordinator as? ScheduleCoordinator
        {
            parentCoordinator = scheduleCoordinator
        } else if let scheduleDetailsModalCoordinator = self.parentCoordinator as? ScheduleDetailsModalCoordinator,
                  let scheduleCoordinator = scheduleDetailsModalCoordinator.parentCoordinator as? ScheduleCoordinator
        {
            parentCoordinator = scheduleCoordinator
        } else if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            parentCoordinator = scheduleCoordinator
        }

        dismissAll()

        return parentCoordinator
    }

    func dismiss(animated: Bool) {
        if isFirstModal {
            navigationController.dismiss(animated: animated)

            return
        }

        navigationController.popViewController(animated: !animated)
    }

    func dismissAll() {
        dismiss(animated: isFirstModal)

        if let focusImediateCoordinator = parentCoordinator as? FocusImediateCoordinator {
            focusImediateCoordinator.dismiss(animated: false)
        }

        if let scheduleDetailsModalCoordinator = parentCoordinator as? ScheduleDetailsModalCoordinator {
            scheduleDetailsModalCoordinator.dismiss(animated: false)
        }

        if let scheduleNotificationCoordinator = parentCoordinator as? ScheduleNotificationCoordinator {
            scheduleNotificationCoordinator.dismiss(animated: false)
        }
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

extension FocusSelectionCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromVC) {
            return
        }

        if let focusPickerVC = fromVC as? FocusPickerViewController {
            childDidFinish(focusPickerVC.coordinator as? Coordinator)
        }
    }
}
