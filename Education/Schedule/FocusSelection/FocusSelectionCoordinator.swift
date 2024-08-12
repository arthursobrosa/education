//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionCoordinator: Coordinator, ShowingFocusPicker, ShowingTimer, Dismissing, DismissingAll, DismissingAfterModal {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let color: UIColor?
    private let subject: Subject?
    private let blocksApps: Bool
    
    init(navigationController: UINavigationController, color: UIColor?, subject: Subject?, blocksApps: Bool) {
        self.navigationController = navigationController
        self.color = color
        self.subject = subject
        self.blocksApps = blocksApps
    }
    
    func start() {
        let viewModel = FocusSelectionViewModel(subject: self.subject, blocksApps: self.blocksApps)
        let vc = FocusSelectionViewController(viewModel: viewModel, color: self.color)
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFocusPicker(timerCase: TimerCase?, blocksApps: Bool) {
        let child = FocusPickerCoordinator(navigationController: self.navigationController, timerCase: timerCase, color: self.color, subject: self.subject, blocksApps: blocksApps)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showTimer<T: UIViewControllerTransitioningDelegate>(transitioningDelegate: T, timerState: FocusSessionViewModel.TimerState?, totalSeconds: Int, timerSeconds: Int, subject: Subject?, timerCase: TimerCase, isAtWorkTime: Bool, blocksApps: Bool, isTimeCountOn: Bool, isAlarmOn: Bool) {
        let viewModel = FocusSessionViewModel(totalSeconds: totalSeconds, timerSeconds: timerSeconds, subject: subject, timerCase: timerCase, isAtWorkTime: isAtWorkTime, blocksApps: blocksApps, isTimeCountOn: isTimeCountOn, isAlarmOn: isAlarmOn)
        viewModel.timerState.value = timerState
        let vc = FocusSessionViewController(viewModel: viewModel, color: self.color)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.transitioningDelegate = transitioningDelegate
        
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
