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
    private let isFirstModal: Bool
    private var newNavigationController = UINavigationController()
    
    private let focusSessionModel: FocusSessionModel
    
    init(navigationController: UINavigationController, isFirstModal: Bool, focusSessionModel: FocusSessionModel) {
        self.navigationController = navigationController
        self.isFirstModal = isFirstModal
        self.focusSessionModel = focusSessionModel
    }
    
    func start() {
        let viewModel = FocusSelectionViewModel(focusSessionModel: self.focusSessionModel)
        let vc = FocusSelectionViewController(viewModel: viewModel, color: self.focusSessionModel.color)
        vc.coordinator = self
        
        if isFirstModal {
            self.newNavigationController = UINavigationController(rootViewController: vc)
            
            self.newNavigationController.delegate = self
            if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
                self.newNavigationController.transitioningDelegate = scheduleCoordinator
            }
            
            self.newNavigationController.setNavigationBarHidden(true, animated: false)
            
            self.newNavigationController.modalPresentationStyle = .overFullScreen
            self.newNavigationController.modalTransitionStyle = .crossDissolve
            
            self.navigationController.present(self.newNavigationController, animated: true)
            
            return
        }
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFocusPicker(focusSessionModel: FocusSessionModel) {
        let child = FocusPickerCoordinator(navigationController: self.isFirstModal ? self.newNavigationController : self.navigationController, focusSessionModel: focusSessionModel)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showTimer(focusSessionModel: FocusSessionModel) {
        guard let scheduleCoordinator = self.getParentCoordinator() as? ScheduleCoordinator else { return }
        
        scheduleCoordinator.showTimer(focusSessionModel: focusSessionModel)
    }
    
    func getParentCoordinator() -> Coordinator? {
        var parentCoordinator: Coordinator?
        
        if let focusImediateCoordinator = self.parentCoordinator as? FocusImediateCoordinator,
           let scheduleCoordinator = focusImediateCoordinator.parentCoordinator as? ScheduleCoordinator {
            parentCoordinator = scheduleCoordinator
        } else if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            parentCoordinator = scheduleCoordinator
        }
        
        self.dismissAll(animated: false)
        
        return parentCoordinator
    }
    
    func dismiss() {
        if isFirstModal {
            self.navigationController.dismiss(animated: true)
            
            return
        }
        
        self.navigationController.popViewController(animated: true)
    }
    
    func dismissAll(animated: Bool) {
        self.dismiss()
        
        if let focusImediateCoordinator = self.parentCoordinator as? FocusImediateCoordinator {
            focusImediateCoordinator.dismiss()
        }
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

extension FocusSelectionCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        
        if let focusPickerVC = fromVC as? FocusPickerViewController {
            self.childDidFinish(focusPickerVC.coordinator as? Coordinator)
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

extension FocusSelectionCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        self.dismissAll(animated: true)
        
        return ActivityManager.shared.handleActivityDismissed(dismissed)
    }
}
