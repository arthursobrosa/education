//
//  FocusPickerViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

class FocusPickerViewModel {
    private let blockingManager: BlockingManager
    
    var focusSessionModel: FocusSessionModel
    
    var selectedTimerHours = Int()
    var selectedTimerMinutes: Int = 1
    
    var selectedWorkHours = Int()
    var selectedWorkMinutes: Int = 25
    
    var selectedRestHours = Int()
    var selectedRestMinutes: Int = 5
    
    var selectedRepetitions: Int = 1
    
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
    
    let repetitions: [Int] = {
        var repetitions = [Int]()
        
        for repetition in 1...9 {
            repetitions.append(repetition)
        }
        
        return repetitions
    }()
    
    
    init(focusSessionModel: FocusSessionModel, blockingManager: BlockingManager) {
        self.focusSessionModel = focusSessionModel
        self.blockingManager = blockingManager
    }
    
    func unblockApps() {
        blockingManager.removeShields()
    }
    
    #warning("get back to normal pomodoro config after tests")
    private func setTimerCase() {
        switch self.focusSessionModel.timerCase {
            case .pomodoro:
                let selectedWorkTime = self.selectedWorkHours * 3600 + self.selectedWorkMinutes * 60
                let selectedRestTime = self.selectedRestHours * 3600 + self.selectedRestMinutes * 60
                let selectedNumberOfLoops = self.selectedRepetitions + 1
                

                self.focusSessionModel.timerCase = .pomodoro(workTime: selectedWorkTime / 60, restTime: selectedRestTime / 60, numberOfLoops: selectedNumberOfLoops)
                self.focusSessionModel.workTime = selectedWorkTime / 60
                self.focusSessionModel.restTime = selectedRestTime / 60
                self.focusSessionModel.numberOfLoops = selectedNumberOfLoops
            default:
                break
        }
    }
    
    private func getTotalTime() {
        var totalTime = Int()
        
        switch self.focusSessionModel.timerCase {
            case .timer:
                totalTime = self.selectedTimerHours * 3600 + self.selectedTimerMinutes * 60
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
    
    func getHoursAndMinutes(from seconds: Int) -> [Int] {
        let minutes = seconds / 60 % 60
        let hours = seconds / 3600
        
        return [hours, minutes]
    }
}
