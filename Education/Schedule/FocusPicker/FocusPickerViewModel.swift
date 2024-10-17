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
    
    var selectedTimerHours = 0
    var selectedTimerMinutes = 5
    
    var selectedWorkHours = 0
    var selectedWorkMinutes = 25
    
    var selectedRestHours = 0
    var selectedRestMinutes = 5
    
    var selectedRepetitions = 1
    
    let hours: [Int] = Array(0..<24)
    let minutes: [Int] = Array(0..<60)
    let repetitions: [Int] = Array(1...9)
    
    
    init(focusSessionModel: FocusSessionModel, blockingManager: BlockingManager) {
        self.focusSessionModel = focusSessionModel
        self.blockingManager = blockingManager
    }
    
    func unblockApps() {
        blockingManager.removeShields()
    }
    
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
    
    func getHoursAndMinutes(from seconds: Int) -> (hours: Int, minutes: Int) {
        let minutes = seconds / 60 % 60
        let hours = seconds / 3600
        
        return (hours, minutes)
    }
}
