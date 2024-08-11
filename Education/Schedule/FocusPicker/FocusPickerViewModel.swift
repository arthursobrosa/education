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
    var isTimeCountOn: Bool = true
    var selectedHours = Int()
    var selectedMinutes: Int = 1
    
    var selectedWorkTime: Int
    var selectedRestTime: Int
    var selectedNumberOfLoops: Int
    
    let hours: [Int] = {
        var hours = [Int]()
        
        for hour in 0..<24 {
            hours.append(hour)
        }
        
        return hours
    }()
    
    let minutes: [Int] = {
        var minutes = [Int]()
        
        for minute in 1..<60 {
            minutes.append(minute)
        }
        
        return minutes
    }()
    
    let blocksApps: Bool
    
    init(timerCase: TimerCase?, subject: Subject?, blocksApps: Bool) {
        self.timerCase = timerCase
        self.subject = subject
        self.blocksApps = blocksApps
        
        switch timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.selectedWorkTime = workTime
                self.selectedRestTime = restTime
                self.selectedNumberOfLoops = numberOfLoops
            default:
                self.selectedWorkTime = Int()
                self.selectedRestTime = Int()
                self.selectedNumberOfLoops = Int()
        }
    }
    
    func getTotalTime() -> Int {
        guard let timerCase else { return 0 }
        
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
        guard let timerCase else { return }
        
        switch timerCase {
            case .pomodoro:
                self.timerCase = .pomodoro(workTime: self.selectedWorkTime, restTime: self.selectedRestTime, numberOfLoops: self.selectedNumberOfLoops)
            default:
                break
        }
    }
}
