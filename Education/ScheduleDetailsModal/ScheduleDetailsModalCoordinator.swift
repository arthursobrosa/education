//
//  ScheduleDetailsModalCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 15/08/24.
//

import UIKit

class ScheduleDetailsModalCoordinator: Coordinator, ShowingFocusSelection, Dismissing, DismissingAll, DismissingAfterModal, ShowingScheduleDetails {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let color: UIColor?
    private let schedule: Schedule
    
    init(navigationController: UINavigationController, color: UIColor?, schedule: Schedule) {
        self.navigationController = navigationController
        self.color = color
        self.schedule = schedule
    }
    
    func start() {
        let viewModel = ScheduleDetailsModalViewModel(schedule: schedule)
        let vc = ScheduleDetailsModalViewController(viewModel: viewModel, color: self.color)
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFocusSelection(color: UIColor?, subject: Subject?, blocksApps: Bool) {
        let child = FocusSelectionCoordinator(navigationController: self.navigationController, color: color, subject: subject, blocksApps: blocksApps)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
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
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
    
    func dismissAll() {
        self.navigationController.popToRootViewController(animated: true)
    }
    
    func dismissAfterModal() {
        self.dismissAll()
        
        if let focusImediateCoordinator = self.parentCoordinator as? FocusImediateCoordinator,
           let scheduleCoordinator = focusImediateCoordinator.parentCoordinator {
            focusImediateCoordinator.childDidFinish(self)
            scheduleCoordinator.childDidFinish(focusImediateCoordinator)
            
            return
        } else if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            scheduleCoordinator.childDidFinish(self)
            
            return
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
