//
//  ShowingScheduleDetails.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/07/24.
//

import Foundation

protocol ShowingScheduleDetails: AnyObject {
    func showScheduleDetails(schedule: Schedule?, title: String?, selectedDay: Int)
}
