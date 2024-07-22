//
//  ScheduleCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleCoordinator: Coordinator, ShowingScheduleDetails {
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
    
    func showScheduleDetails(schedule: Schedule?, title: String?, selectedDay: Int) {
        let viewModel = ScheduleDetailsViewModel(schedule: schedule, selectedDay: selectedDay)
        let vc = ScheduleDetailsViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .pageSheet
        vc.title = "\(title ?? String(localized: "newSchedule")) \(String(localized: "schedule"))"
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let scheduleVC = self.navigationController.viewControllers.first as? ScheduleViewController {
            nav.transitioningDelegate = scheduleVC
        }
        
        self.navigationController.present(nav, animated: true)
    }
}

