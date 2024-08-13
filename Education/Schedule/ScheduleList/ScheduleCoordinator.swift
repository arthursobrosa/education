//
//  ScheduleCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleCoordinator: NSObject, Coordinator, ShowingScheduleDetails, ShowingFocusImediate, ShowingFocusSelection, ShowingTimer {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        let viewModel = ScheduleViewModel()
        let vc = ScheduleViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = String(localized: "schedule")
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showScheduleDetails(title: String?, schedule: Schedule?, selectedDay: Int) {
        let child = ScheduleDetailsCoordinator(navigationController: self.navigationController, title: title, schedule: schedule, selectedDay: selectedDay)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showFocusImediate() {
        let child = FocusImediateCoordinator(navigationController: self.navigationController)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showFocusSelection(focusSessionModel: FocusSessionModel) {
        let child = FocusSelectionCoordinator(navigationController: self.navigationController, isFirstModal: true, focusSessionModel: focusSessionModel)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showTimer(focusSessionModel: FocusSessionModel) {
        let child = FocusSessionCoordinator(navigationController: self.navigationController, focusSessionModel: focusSessionModel)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
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

extension ScheduleCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let nav = dismissed as? UINavigationController else { return nil }
        
        if let focusImediateVC = nav.viewControllers.first as? FocusImediateViewController {
            self.childDidFinish(focusImediateVC.coordinator as? Coordinator)
        }
        
        if let focusSelectionVC = nav.viewControllers.first as? FocusSelectionViewController {
            self.childDidFinish(focusSelectionVC.coordinator as? Coordinator)
        }
        
        if let focusSessionVC = nav.viewControllers.first as? FocusSessionViewController {
            ActivityManager.shared.handleActivityDismissed(focusSessionVC: focusSessionVC)
            
            self.childDidFinish(focusSessionVC.color as? Coordinator)
        }
        
        if let scheduleDetailsVC = nav.viewControllers.first as? ScheduleDetailsViewController {
            self.childDidFinish(scheduleDetailsVC.coordinator)
            
            guard let scheduleVC = self.navigationController.viewControllers.first as? ScheduleViewController else { return nil }
            
            scheduleVC.loadSchedules()
        }
        
        return nil
    }
}

