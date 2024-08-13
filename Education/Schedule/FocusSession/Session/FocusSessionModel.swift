//
//  FocusSessionModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class FocusSessionModel {
    var timerState: FocusSessionViewModel.TimerState?
    var totalSeconds: Int
    var timerSeconds: Int
    var timerCase: TimerCase
    var subject: Subject?
    var blocksApps: Bool
    var isTimeCountOn: Bool
    var isAlarmOn: Bool
    
    var isAtWorkTime: Bool
    var workTime = Int()
    var restTime = Int()
    var numberOfLoops = Int()
    var currentLoop = Int()
    
    var color: UIColor?
    
    init(timerState: FocusSessionViewModel.TimerState?, totalSeconds: Int, timerSeconds: Int, timerCase: TimerCase, subject: Subject?, isAtWorkTime: Bool, blocksApps: Bool, isTimeCountOn: Bool, isAlarmOn: Bool, color: UIColor?) {
        self.timerState = timerState
        self.totalSeconds = totalSeconds
        self.timerSeconds = timerSeconds
        self.timerCase = timerCase
        self.subject = subject
        self.isAtWorkTime = isAtWorkTime
        self.blocksApps = blocksApps
        self.isTimeCountOn = isTimeCountOn
        self.isAlarmOn = isAlarmOn
        self.color = color
        
        switch self.timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.workTime = workTime
                self.restTime = restTime
                self.numberOfLoops = numberOfLoops
            default:
                break
        }
    }
}
