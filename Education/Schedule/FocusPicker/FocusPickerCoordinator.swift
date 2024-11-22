//
//  FocusPickerCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerCoordinator: Coordinator, ShowingTimer, Dismissing, DismissingAll {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let focusSessionModel: FocusSessionModel
    private let blockingManager: BlockingManager

    init(navigationController: UINavigationController, focusSessionModel: FocusSessionModel, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.focusSessionModel = focusSessionModel
        self.blockingManager = blockingManager
    }

    func start() {
        let viewModel = FocusPickerViewModel(focusSessionModel: focusSessionModel, blockingManager: blockingManager)
        let viewController = FocusPickerViewController(viewModel: viewModel)
        viewController.navigationItem.hidesBackButton = true
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: false)
    }

    func showTimer(focusSessionModel: FocusSessionModel?) {
        guard let parentCoordinator = getParentCoordinator() as? ScheduleCoordinator else { return }

        parentCoordinator.showTimer(focusSessionModel: focusSessionModel)
    }

    func getParentCoordinator() -> Coordinator? {
        var parentCoordinator: Coordinator?

        if let focusSelectionCoordinator = self.parentCoordinator as? FocusSelectionCoordinator {
            parentCoordinator = focusSelectionCoordinator.getParentCoordinator()
        }

        return parentCoordinator
    }

    func dismiss(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func dismissAll() {
        dismiss(animated: false)

        if let focusSelectionCoordinator = parentCoordinator as? FocusSelectionCoordinator {
            if focusSelectionCoordinator.isFirstModal {
                focusSelectionCoordinator.dismiss(animated: false)
                return
            }

            focusSelectionCoordinator.dismissAll()
        }
    }
}
