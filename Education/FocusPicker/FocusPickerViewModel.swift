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
    var selectedTime = Int()
    
    func setSelectedTime(_ date: Date)  {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        guard let hour = components.hour,
              let minute = components.minute else { return }
        
        self.selectedTime = (hour * 60 + minute) * 60
    }
}
