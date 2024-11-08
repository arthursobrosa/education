//
//  ScheduleCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleCoordinator: NSObject,
                           Coordinator,
                           ShowingScheduleDetails,
                           ShowingFocusImediate,
                           ShowingScheduleNotification,
                           ShowingTimer,
                           ShowingScheduleDetailsModal,
                           ShowingFocusSelection,
                           ShowingSubjectCreation {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let activityManager: ActivityManager
    private let blockingManager: BlockingManager
    private let notificationService: NotificationServiceProtocol?

    init(navigationController: UINavigationController, activityManager: ActivityManager, blockingManager: BlockingManager, notificationService: NotificationServiceProtocol?) {
        self.navigationController = navigationController
        self.activityManager = activityManager
        self.blockingManager = blockingManager
        self.notificationService = notificationService
    }

    func start() {
        navigationController.navigationBar.prefersLargeTitles = true

        let viewModel = ScheduleViewModel()
        let viewController = ScheduleViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: false)
    }

    func showScheduleDetails(schedule: Schedule?, selectedDay: Int?) {
        let child = ScheduleDetailsCoordinator(navigationController: navigationController, notificationService: notificationService, schedule: schedule, selectedDay: selectedDay)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showFocusImediate() {
        let child = FocusImediateCoordinator(navigationController: navigationController, blockingManager: blockingManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showScheduleNotification(subjectName: String, startTime: Date, endTime: Date) {
        let child = ScheduleNotificationCoordinator(navigationController: navigationController, subjectName: subjectName, startTime: startTime, endTime: endTime, blockingManager: blockingManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showFocusSelection(focusSessionModel: FocusSessionModel) {
        let child = FocusSelectionCoordinator(navigationController: navigationController, isFirstModal: true, focusSessionModel: focusSessionModel, blockingManager: blockingManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showTimer(focusSessionModel: FocusSessionModel?) {
        if let focusSessionModel {
            activityManager.finishSession()
            activityManager.updateFocusSession(with: focusSessionModel)
            activityManager.isPaused = false
        }

        let child = FocusSessionCoordinator(navigationController: navigationController, activityManager: activityManager, blockingManager: blockingManager)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showScheduleDetailsModal(schedule: Schedule) {
        let child = ScheduleDetailsModalCoordinator(navigationController: navigationController, blockingManager: blockingManager, schedule: schedule)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showSubjectCreation(viewModel: StudyTimeViewModel) {
        let child = SubjectCreationCoordinator(navigationController: navigationController, viewModel: viewModel)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension ScheduleCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let nav = dismissed as? UINavigationController else { return nil }

        if let focusImediateVC = nav.viewControllers.first as? FocusImediateViewController {
            childDidFinish(focusImediateVC.coordinator as? Coordinator)
        }

        if let focusSelectionVC = nav.viewControllers.first as? FocusSelectionViewController {
            childDidFinish(focusSelectionVC.coordinator as? Coordinator)
        }

        if let focusSessionVC = nav.viewControllers.first as? FocusSessionViewController {
            activityManager.handleDismissedActivity(didTapFinish: focusSessionVC.viewModel.didTapFinish)

            childDidFinish(focusSessionVC.coordinator as? Coordinator)
        }

        if let scheduleDetailsVC = nav.viewControllers.first as? ScheduleDetailsViewController {
            childDidFinish(scheduleDetailsVC.coordinator as? Coordinator)

            guard let scheduleVC = navigationController.viewControllers.first as? ScheduleViewController else { return nil }

            let dayViews = scheduleVC.scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }
            let weekdays = scheduleVC.viewModel.daysOfWeek.compactMap { scheduleVC.viewModel.getWeekday(from: $0) }
            
            if let selectedDayView = scheduleDetailsVC.viewModel.getSelectedDayView(dayViews: dayViews, weekdays: weekdays) {
                scheduleVC.dayTapped(selectedDayView)
            }
            
            scheduleVC.loadSchedules()
        }

        if let scheduleDetailsModalVC = nav.viewControllers.first as? ScheduleDetailsModalViewController {
            childDidFinish(scheduleDetailsModalVC.coordinator as? Coordinator)
        }

        if let subjectCreationVC = nav.viewControllers.first as? SubjectCreationViewController {
            childDidFinish(subjectCreationVC.coordinator as? Coordinator)

            if let scheduleVC = navigationController.viewControllers.first as? ScheduleViewController {
                scheduleVC.loadSchedules()
            }
        }

        return nil
    }
}
