//
//  FocusPickerViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

class FocusPickerViewModel {
    var isAlarmOn: Bool = false
    var isTimeCountOn: Bool = false
    var selectedHours = Int()
    var selectedMinutes = Int()
    var selectedTime = Int()
    
    let hours: [Int] = {
        var hours = [Int]()
        
        for hour in 0..<24 {
            hours.append(hour)
        }
        
        return hours
    }()
    
    let minutes: [Int] = {
        var minutes = [Int]()
        
        for minute in 0..<60 {
            minutes.append(minute)
        }
        
        return minutes
    }()
    
    func setSelectedTime() {
        self.selectedTime = self.selectedHours * 3600 + self.selectedMinutes * 60
    }
}
