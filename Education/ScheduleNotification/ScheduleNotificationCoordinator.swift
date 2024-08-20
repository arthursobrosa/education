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
    
    private let schedule: Schedule
    
    init(navigationController: UINavigationController, schedule: Schedule) {
        self.navigationController = navigationController
        self.schedule = schedule
    }
    
    func start() {
        let viewModel = ScheduleNotificationViewModel(schedule: self.schedule)
        let vc = ScheduleNotificationViewController(color: .red, viewModel: viewModel)
        vc.coordinator = self
        
        self.newNavigationController = UINavigationController(rootViewController: vc)
        
        self.newNavigationController.delegate = self
        if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            self.newNavigationController.transitioningDelegate = scheduleCoordinator
        }
        
        self.newNavigationController.setNavigationBarHidden(true, animated: false)
        
        self.newNavigationController.modalPresentationStyle = .overFullScreen
        self.newNavigationController.modalTransitionStyle = .crossDissolve
        
        self.navigationController.present(self.newNavigationController, animated: true)
    }
    
    func showFocusSelection(focusSessionModel: FocusSessionModel) {
        let child = FocusSelectionCoordinator(navigationController: self.navigationController, isFirstModal: false, focusSessionModel: focusSessionModel)
        child.parentCoordinator = self.parentCoordinator
        self.parentCoordinator!.childCoordinators.append(child)
        child.start()
        
        self.navigationController.dismiss(animated: true)
    }
    
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension ScheduleNotificationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        
        if let focusSelectionVC = fromVC as? FocusSelectionViewController {
            self.childDidFinish(focusSelectionVC.coordinator as? Coordinator)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        if operation == .push {
            return CustomPushTransition()
        }
        
        if operation == .pop {
            return CustomPopTransition()
        }
        
        return nil
    }
}
