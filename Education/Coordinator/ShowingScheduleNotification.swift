//
//  ShowingScheduleNotification.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import Foundation

protocol ShowingScheduleNotification: AnyObject {
    func showScheduleNotification(schedule: Schedule)
}

//func showScheduleDetailsModal(schedule: Schedule) {
//    let child = ScheduleNotificationCoordinator(navigationController: self.navigationController, schedule: schedule)
//    self.childCoordinators.append(child)
//    child.parentCoordinator = self
//    child.start()
//}
