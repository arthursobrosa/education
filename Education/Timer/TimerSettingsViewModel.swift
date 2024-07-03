//
//  TimerSettingsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import Foundation

class TimerSettingsViewModel {
    var selectedTime: TimeInterval = 0 // Variable to hold the selected time
    
    func printSelectedTime() {
        let hours = Int(selectedTime) / 3600
        let minutes = (Int(selectedTime) % 3600) / 60
        print("Selected time is \(hours) hours and \(minutes) minutes.")
    }
}
