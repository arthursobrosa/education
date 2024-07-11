//
//  ScheduleCreationViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import Foundation

class ScheduleCreationViewModel {
    var subjects: [String] = ["Math", "Geo", "Science", "History"]
    lazy var selectedSubject = self.subjects[0]
    
    var days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    lazy var selectedDay = self.days[0]
    
    var selectedStartTime = Date()
    var selectedEndTime = Date()
}
