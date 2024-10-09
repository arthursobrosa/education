//
//  FocusSessionModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class FocusSessionModel {
    var date: Date
    var totalSeconds: Int
    var timerSeconds: Int
    var timerCase: TimerCase
    var subject: Subject?
    var isAtWorkTime: Bool
    var blocksApps: Bool
    var isTimeCountOn: Bool
    var isAlarmOn: Bool
    var color: UIColor?
    
    var workTime = Int()
    var restTime = Int()
    var numberOfLoops = Int()
    var currentLoop = Int()
    
    init(date: Date = Date.now, totalSeconds: Int = 1, timerSeconds: Int = 1, timerCase: TimerCase = .timer, subject: Subject? = nil, isAtWorkTime: Bool = true, blocksApps: Bool = false, isTimeCountOn: Bool = true, isAlarmOn: Bool = false, color: UIColor? = nil) {
        self.date = date
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
