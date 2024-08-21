//
//  ShowingScheduleNotification.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import Foundation

protocol ShowingScheduleNotification: AnyObject {
    func showScheduleNotification(subjectName: String, startTime: Date, endTime: Date)
}
