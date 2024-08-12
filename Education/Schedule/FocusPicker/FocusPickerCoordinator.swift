//
//  FocusPickerCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerCoordinator: Coordinator, ShowingTimer, Dismissing, DismissingAll, DismissingAfterModal {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var timerCase: TimerCase?
    private let color: UIColor?
    private let subject: Subject?
    private let blocksApps: Bool
    
    init(navigationController: UINavigationController, timerCase: TimerCase?, color: UIColor?, subject: Subject?, blocksApps: Bool) {
        self.navigationController = navigationController
        self.timerCase = timerCase
        self.color = color
        self.subject = subject
        self.blocksApps = blocksApps
    }
    
    func start() {
        let viewModel = FocusPickerViewModel(timerCase: self.timerCase, subject: self.subject, blocksApps: self.blocksApps)
        let vc = FocusPickerViewController(viewModel: viewModel, color: self.color)
        vc.navigationItem.hidesBackButton = true
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: true)
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
        
        if let focusSelectionCoordinator = self.parentCoordinator as? FocusSelectionCoordinator {
            if let focusImediateCoordinator = focusSelectionCoordinator.parentCoordinator as? FocusImediateCoordinator,
               let scheduleCoordinator = focusImediateCoordinator.parentCoordinator {
                focusSelectionCoordinator.childDidFinish(self)
                focusImediateCoordinator.childDidFinish(focusSelectionCoordinator)
                scheduleCoordinator.childDidFinish(focusImediateCoordinator)
                
                return
            } else if let scheduleCoordinator = focusSelectionCoordinator.parentCoordinator as? ScheduleCoordinator {
                focusSelectionCoordinator.childDidFinish(self)
                scheduleCoordinator.childDidFinish(focusSelectionCoordinator)
                
                return
            }
        }
    }
}
