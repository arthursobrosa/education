//
//  ShowingScheduleDetails.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/07/24.
//

import Foundation

protocol ShowingScheduleDetails: AnyObject {
    func showScheduleDetails(title: String?, schedule: Schedule?, selectedDay: Int)
}
