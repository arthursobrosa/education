//
//  FocusPickerViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

class FocusPickerViewModel {
    let subject: Subject?
    var timerCase: TimerCase?
    
    var isAlarmOn: Bool = false
    var isTimeCountOn: Bool = false
    var selectedHours = Int()
    var selectedMinutes = Int()
    
    var selectedWorkTime = Int()
    var selectedRestTime = Int()
    
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
    
    init(timerCase: TimerCase?, subject: Subject?) {
        self.timerCase = timerCase
        self.subject = subject
    }
    
    func getTotalTime() -> Int {
        guard let timerCase = timerCase else { return 0 }
        
        var totalTime = Int()
        
        switch timerCase {
            case .timer:
                totalTime = self.selectedHours * 3600 + self.selectedMinutes * 60
            case .pomodoro(let worktime, _, _):
                totalTime = worktime
            default:
                break
        }
        
        return totalTime
    }
    
    func setTimerCase() {
        guard let timerCase = self.timerCase else { return }
        
        switch timerCase {
            case .pomodoro:
                self.timerCase = .pomodoro(workTime: self.selectedWorkTime, restTime: self.selectedRestTime, numberOfLoops: 2)
            default:
                break
        }
    }
}
