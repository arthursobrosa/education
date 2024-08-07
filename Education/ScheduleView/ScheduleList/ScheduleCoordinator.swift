//
//  ScheduleCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleCoordinator: NSObject, Coordinator, ShowingScheduleDetails, ShowingFocusSelection, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.delegate = self
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        let viewModel = ScheduleViewModel()
        let vc = ScheduleViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = String(localized: "schedule")
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showScheduleDetails(schedule: Schedule?, title: String?, selectedDay: Int) {
        let viewModel = ScheduleDetailsViewModel(schedule: schedule, selectedDay: selectedDay)
        let vc = ScheduleDetailsViewController(viewModel: viewModel)
        vc.title = "\(title ?? String(localized: "newSchedule")) \(String(localized: "schedule"))"
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        
        if let scheduleVC = self.navigationController.viewControllers.first as? ScheduleViewController {
            nav.transitioningDelegate = scheduleVC
        }
        
        self.navigationController.present(nav, animated: true)
    }
    
    func showFocusSelection(color: UIColor?, subject: Subject?) {
        let child = FocusSelectionCoordinator(navigationController: self.navigationController, color: color, subject: subject)
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
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = self.navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if self.navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let focusSelectionViewController = fromViewController as? FocusSelectionViewController {
            if let scheduleViewController = viewController as? ScheduleViewController {
//                scheduleViewController.currentActivityColor = focusSelectionViewController.color
            }
            
            self.childDidFinish(focusSelectionViewController.coordinator as? Coordinator)
        }
        
        if let focusPickerViewController = fromViewController as? FocusPickerViewController {
            if let scheduleViewController = viewController as? ScheduleViewController {
//                scheduleViewController.currentActivityColor = focusPickerViewController.color
            }
            
            self.childDidFinish(focusPickerViewController.coordinator as? Coordinator)
        }
    }
}

