//
//  FocusSessionCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class FocusSessionCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var newNavigationController = UINavigationController()
    
    private let activityManager: ActivityManager
    
    init(navigationController: UINavigationController, activityManager: ActivityManager) {
        self.navigationController = navigationController
        self.activityManager = activityManager
    }
    
    func start() {
        let viewModel = FocusSessionViewModel(activityManager: activityManager)
        let vc = FocusSessionViewController(viewModel: viewModel, color: activityManager.color)
        vc.coordinator = self
        
        self.newNavigationController = UINavigationController(rootViewController: vc)
        
        if let delegateCoordinator = self.getTransitioningDelegate() as? UIViewControllerTransitioningDelegate {
            self.newNavigationController.transitioningDelegate = delegateCoordinator
        }

        self.newNavigationController.modalPresentationStyle = .fullScreen
        
        // This will cause the status bar to be hidden
        self.newNavigationController.setNavigationBarHidden(true, animated: false)
        
        self.navigationController.present(self.newNavigationController, animated: true)
    }
    
    private func getTransitioningDelegate() -> Coordinator? {
        var delegateCoordinator: Coordinator?
        
        if let focusPickerCoordinator = self.parentCoordinator as? FocusPickerCoordinator {
            delegateCoordinator = focusPickerCoordinator
            
            focusPickerCoordinator.dismissAll()
        } else if let focusSelectionCoordinator = self.parentCoordinator as? FocusSelectionCoordinator {
            if let focusImediateCoordinator = focusSelectionCoordinator.parentCoordinator as? FocusImediateCoordinator,
               let scheduleCoordinator = focusImediateCoordinator.parentCoordinator as? ScheduleCoordinator {
                delegateCoordinator = scheduleCoordinator
            } else if let scheduleCoordinator = focusSelectionCoordinator.parentCoordinator as? ScheduleCoordinator {
                delegateCoordinator = scheduleCoordinator
            }
            
            focusSelectionCoordinator.dismissAll()
        } else if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            delegateCoordinator = scheduleCoordinator
        }
        
        return delegateCoordinator
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}
