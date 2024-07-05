//
//  FocusSessionSettingsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import Foundation

class FocusSessionSettingsViewModel {
    var selectedTime: TimeInterval = 60 // Variable to hold the selected time
    
    var selectedSubject = Box(String())
    var subjects = ["None", "Option 1", "Option 2", "Option 3"]
    var isOpened: Bool = false
    var alarmWhenFinished: Bool = true
    var blockApps: Bool = false
    
    init() {
        self.selectedSubject.value = self.subjects[0]
    }
    
    func getTotalSeconds(fromDate date: Date) -> TimeInterval {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let selectedHour = calendar.component(.hour, from: date)
        let selectedMinutes = calendar.component(.minute, from: date)
        
        let currentTotalTime = currentHour * 3600 + currentMinutes * 60 + currentSeconds
        let selectedTotalTime = selectedHour * 3600 + selectedMinutes * 60
        
        let totalTime = selectedTotalTime - currentTotalTime
        
        return TimeInterval(totalTime)
    }
}
