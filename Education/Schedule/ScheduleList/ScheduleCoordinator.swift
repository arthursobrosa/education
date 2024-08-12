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
    var color: UIColor?
    
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
    
    func showFocusImediate() {
        let child = FocusImediateCoordinator(navigationController: self.navigationController)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showFocusSelection(color: UIColor?, subject: Subject?, blocksApps: Bool) {
        let child = FocusSelectionCoordinator(navigationController: self.navigationController, color: color, subject: subject, blocksApps: blocksApps)
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
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension ScheduleCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let focusImediateViewController = fromViewController as? FocusImediateViewController {
            self.childDidFinish(focusImediateViewController.coordinator as? Coordinator)
        }
        
        if let focusSelectionViewController = fromViewController as? FocusSelectionViewController {
            if let _ = navigationController.transitionCoordinator?.viewController(forKey: .to) as? FocusImediateViewController {
                guard let focusImediateCoordinator = self.childCoordinators.first as? FocusImediateCoordinator,
                      let focusSelectionCoordinator = focusImediateCoordinator.childCoordinators.first as? FocusSelectionCoordinator else { return }
                
                focusImediateCoordinator.childDidFinish(focusSelectionCoordinator)
                return
            }
            
            if let focusImediateCoordinator = self.childCoordinators.first as? FocusImediateCoordinator,
               let focusSelectionCoordinator = focusImediateCoordinator.childCoordinators.first as? FocusSelectionCoordinator {
                
                focusImediateCoordinator.childDidFinish(focusSelectionCoordinator)
                self.childDidFinish(focusImediateCoordinator)
                
                return
            }
            
            self.childDidFinish(focusSelectionViewController.coordinator as? Coordinator)
            return
        }
        
        if let _ = fromViewController as? FocusPickerViewController {
            if let _ = navigationController.transitionCoordinator?.viewController(forKey: .to) as? FocusSelectionViewController {
                if let focusImediateCoordinator = self.childCoordinators.first as? FocusImediateCoordinator,
                   let focusSelectionCoordinator = focusImediateCoordinator.childCoordinators.first as? FocusSelectionCoordinator,
                   let focusPickerCoordinator = focusSelectionCoordinator.childCoordinators.first as? FocusPickerCoordinator {
                    focusSelectionCoordinator.childDidFinish(focusPickerCoordinator)
                    return
                }
                
                if let focusSelectionCoordinator = self.childCoordinators.first as? FocusSelectionCoordinator,
                   let focusPickerCoordinator = focusSelectionCoordinator.childCoordinators.first as? FocusPickerCoordinator {
                    focusSelectionCoordinator.childDidFinish(focusPickerCoordinator)
                    return
                }
            }
            
            if let focusImediateCoordinator = self.childCoordinators.first as? FocusImediateCoordinator,
               let focusSelectionCoordinator = focusImediateCoordinator.childCoordinators.first as? FocusSelectionCoordinator,
               let focusPickerCoordinator = focusSelectionCoordinator.childCoordinators.first as? FocusPickerCoordinator {
                focusSelectionCoordinator.childDidFinish(focusPickerCoordinator)
                focusImediateCoordinator.childDidFinish(focusSelectionCoordinator)
                self.childDidFinish(focusImediateCoordinator)
                return
            }
            
            if let focusSelectionCoordinator = self.childCoordinators.first as? FocusSelectionCoordinator,
               let focusPickerCoordinator = focusSelectionCoordinator.childCoordinators.first as? FocusPickerCoordinator {
                focusSelectionCoordinator.childDidFinish(focusPickerCoordinator)
                self.childDidFinish(focusSelectionCoordinator)
                return
            }
        }
        
        if let _ = fromViewController as? UINavigationController {
            if let focusImediateCoordinator = self.childCoordinators.first as? FocusImediateCoordinator,
               let focusSelectionCoordinator = focusImediateCoordinator.childCoordinators.first as? FocusSelectionCoordinator {
                if let focusPickerCoordinator = focusSelectionCoordinator.childCoordinators.first as? FocusPickerCoordinator {
                    focusSelectionCoordinator.childDidFinish(focusPickerCoordinator)
                }
                
                focusImediateCoordinator.childDidFinish(focusSelectionCoordinator)
                self.childDidFinish(focusImediateCoordinator)
            }
            
            if let focusSelectionCoordinator = self.childCoordinators.first as? FocusSelectionCoordinator {
                if let focusPickerCoordinator = focusSelectionCoordinator.childCoordinators.first as? FocusPickerCoordinator {
                    focusSelectionCoordinator.childDidFinish(focusPickerCoordinator)
                }
                
                self.childDidFinish(focusSelectionCoordinator)
                return
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        if let _ = fromVC as? ScheduleViewController {
            ActivityManager.shared.changeActivityVisibility(isShowing: false)
        }
        
        if let _ = toVC as? ScheduleViewController {
            ActivityManager.shared.changeActivityVisibility(isShowing: true)
        }
        
        if operation == .push {
            return CustomPushAnimation()
        }
        
        if operation == .pop {
            return CustomPopAnimation()
        }
        
        return nil
    }
}

