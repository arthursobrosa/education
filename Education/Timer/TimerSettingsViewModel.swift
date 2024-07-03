//
//  TimerSettingsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import Foundation

class TimerSettingsViewModel {
    var selectedTime: TimeInterval = 60 // Variable to hold the selected time
    
    func getTimeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
