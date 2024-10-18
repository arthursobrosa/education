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
    
    #warning("change this afterwards")
    private func setTimerCase() {
        switch focusSessionModel.timerCase {
            case .pomodoro:
                let selectedWorkTime = selectedWorkHours * 3600 + selectedWorkMinutes * 60
                let selectedRestTime = selectedRestHours * 3600 + selectedRestMinutes * 60
                let selectedNumberOfLoops = selectedRepetitions + 1
                
                focusSessionModel.timerCase = .pomodoro(workTime: selectedWorkTime, restTime: selectedRestTime, numberOfLoops: selectedNumberOfLoops)
                focusSessionModel.workTime = selectedWorkTime
                focusSessionModel.restTime = selectedRestTime
                focusSessionModel.numberOfLoops = selectedNumberOfLoops
            default:
                break
        }
    }
    
    private func getTotalTime() {
        var totalTime = Int()
        
        switch focusSessionModel.timerCase {
            case .timer:
                totalTime = selectedTimerHours * 3600 + selectedTimerMinutes * 60
            case .pomodoro(let worktime, _, _):
                totalTime = worktime
            default:
                break
        }

        focusSessionModel.totalSeconds = totalTime
        focusSessionModel.timerSeconds = totalTime
    }
    
    func setFocusSessionModel() {
        setTimerCase()
        getTotalTime()
    }
    
    func getHoursAndMinutes(from seconds: Int) -> (hours: Int, minutes: Int) {
        let minutes = seconds / 60 % 60
        let hours = seconds / 3600
        
        return (hours, minutes)
    }
}
