//
//  FocusImediateCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateCoordinator: NSObject, Coordinator, ShowingFocusSelection, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()

    private let blockingManager: BlockingManager

    init(navigationController: UINavigationController, blockingManager: BlockingManager) {
        self.navigationController = navigationController
        self.blockingManager = blockingManager
    }

    func start() {
        let viewModel = FocusImediateViewModel()
        let vc = FocusImediateViewController(viewModel: viewModel, color: .systemBackground)
        vc.coordinator = self

        newNavigationController = UINavigationController(rootViewController: vc)

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
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension FocusImediateCoordinator: UINavigationControllerDelegate {
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
