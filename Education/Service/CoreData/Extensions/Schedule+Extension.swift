//
//  Schedule+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Schedule {
    var unwrappedID: String {
        id ?? String()
    }

    var unwrappedSubjectID: String {
        subjectID ?? String()
    }

    var unwrappedDay: Int {
        Int(dayOfTheWeek)
    }

    var unwrappedStartTime: Date {
        startTime ?? Date()
    }

    var unwrappedEndTime: Date {
        endTime ?? Date()
    }
    
    var unwrappedAlarms: [Int] {
        String(alarms).compactMap { $0.wholeNumberValue }
    }
    
    func isAlarmOn() -> Bool {
        guard unwrappedAlarms.count == 1,
              let alarm = unwrappedAlarms.first,
              alarm == 0 else {
            
            return false
        }
        
        return true
    }
}
