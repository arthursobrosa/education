//
//  FocusPickerViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

class FocusPickerViewModel {
    var focusSessionModel: FocusSessionModel
    
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
    
    
    init(focusSessionModel: FocusSessionModel) {
        self.focusSessionModel = focusSessionModel
        
        switch self.focusSessionModel.timerCase {
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
    
    private func setTimerCase() {
        switch self.focusSessionModel.timerCase {
            case .pomodoro:
                self.focusSessionModel.timerCase = .pomodoro(workTime: self.selectedWorkTime, restTime: self.selectedRestTime, numberOfLoops: self.selectedNumberOfLoops)
            default:
                break
        }
    }
    
    private func getTotalTime() {
        var totalTime = Int()
        
        switch self.focusSessionModel.timerCase {
            case .timer:
                totalTime = self.selectedHours * 3600 + self.selectedMinutes * 60
            case .pomodoro(let worktime, _, _):
                totalTime = worktime
            default:
                break
        }
        
        self.focusSessionModel.totalSeconds = totalTime
        self.focusSessionModel.timerSeconds = totalTime
    }
    
    func setFocusSessionModel() {
        self.setTimerCase()
        self.getTotalTime()
    }
}
