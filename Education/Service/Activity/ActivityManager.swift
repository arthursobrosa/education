//
//  ActivityManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/08/24.
//

import UIKit

enum TimerCase {
    case stopwatch
    case timer
    case pomodoro(workTime: Int, restTime: Int, numberOfLoops: Int)
}

class ActivityManager {
    // MARK: - Shared Instance
    static let shared = ActivityManager()
    
    // MARK: - Delegate and FocusSession manager
    weak var delegate: TabBarDelegate?
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Timer properties
    var timerCase: TimerCase
    
    var startTime: Date?
    private var pausedTime: TimeInterval = 0
    var timer: Timer?
    
    @Published var timerDidFinish: Bool = false
    
    var totalSeconds: Int
    @Published var timerSeconds: Int
    
    var isAtWorkTime: Bool = true
    var workTime: Int = 0
    var restTime: Int = 0
    var numberOfLoops: Int = 0
    var currentLoop: Int = 0
    
    var progress: CGFloat = 0
    
    @Published var isPaused: Bool {
        didSet {
            isPaused ? self.stopTimer() : self.startTimer()
        }
    }
    
    @Published var updateAfterBackground: Bool = false
    
    var isShowingActivity: Bool = false {
        didSet {
            if isShowingActivity {
                self.delegate?.addActivityView()
                self.delegate?.changeActivityVisibility(isShowing: true)
                self.delegate?.updateActivityTimer()
                
                return
            }
            
            self.delegate?.removeActivityView()
        }
    }
    
    // MARK: - Schedule properties
    var date: Date
    
    var subject: Subject?
    var blocksApps: Bool
    var isTimeCountOn: Bool
    var isAlarmOn: Bool
    
    var color: UIColor?
    
    // MARK: - Initializer
    init(focusSessionManager: FocusSessionManager = FocusSessionManager(), timerCase: TimerCase = .timer, totalSeconds: Int = 1, timerSeconds: Int = 1, isPaused: Bool = true, date: Date = Date(), subject: Subject? = nil, blocksApps: Bool = false, isTimeCountOn: Bool = true, isAlarmOn: Bool = false, color: UIColor? = nil) {
        self.focusSessionManager = focusSessionManager
        
        self.timerCase = timerCase
        self.totalSeconds = totalSeconds
        self.timerSeconds = timerSeconds
        self.isPaused = isPaused
        
        self.date = date
        self.subject = subject
        self.blocksApps = blocksApps
        self.isTimeCountOn = isTimeCountOn
        self.isAlarmOn = isAlarmOn
        self.color = color
    }
    
    // MARK: - Methods
    private func startTimer() {
        switch self.timerCase {
            case .stopwatch:
                self.startStopwatch()
                return
            default:
                break
        }
        
        if self.startTime == nil {
            self.startTime = Date()
        } else {
            self.startTime = Date().addingTimeInterval(-self.pausedTime)
        }
            
        self.timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            let elapsed = Date().timeIntervalSince(self.startTime ?? Date())
            progress = CGFloat(min(elapsed / Double(self.totalSeconds), 1))
            
            let remainingTime = max(self.totalSeconds - Int(elapsed), 0)
            self.timerSeconds = remainingTime
            
            if self.isShowingActivity {
                self.delegate?.updateActivityTimer()
            }
            
            if elapsed >= Double(self.totalSeconds) {
                self.handleTimerEnd()
            }
            
            switch timerCase {
                case .pomodoro:
                    if self.updateAfterBackground {
                        self.updateAfterBackground = true
                        self.updateAfterBackground = false
                    }
                default:
                    break
            }
        }
    }
    
    private func startStopwatch() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.progress = 0
            self.timerSeconds += 1
            
            if self.isShowingActivity {
                self.delegate?.updateActivityTimer()
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        
        switch self.timerCase {
        case .timer:
            NotificationService.shared.cancelNotificationByName(name: self.subject!.unwrappedName)
        case .pomodoro(_, _, _):
            NotificationService.shared.cancelNotificationByName(name: self.subject!.unwrappedName)
        default:
            break
        }
        
        
        if let startTime = self.startTime {
            self.pausedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    func resetTimer() {
        self.isPaused = true
        
        self.timerDidFinish = false
        
        self.progress = 0
        self.totalSeconds = 0
        self.timerSeconds = 0
        self.pausedTime = 0
        self.startTime = nil
        
        self.isAtWorkTime = true
        self.workTime = 0
        self.restTime = 0
        self.numberOfLoops = 0
        self.currentLoop = 0
    }
    
    private func handleTimerEnd() {
        switch self.timerCase {
            case .timer:
                self.stopTimer()
                self.timerDidFinish = true
                
                return
            case .pomodoro:
                if self.isAtWorkTime {
                    if self.currentLoop >= self.numberOfLoops - 1 {
                        self.stopTimer()
                        self.timerDidFinish = true
                        
                        return
                    }
                    
                    self.isAtWorkTime.toggle()
                    self.totalSeconds = self.restTime
                    self.timerSeconds = self.totalSeconds
                } else {
                    self.currentLoop += 1
                    self.isAtWorkTime.toggle()
                    self.totalSeconds = self.workTime
                    self.timerSeconds = self.totalSeconds
                }
                
                self.startTime = nil
                self.pausedTime = 0
                self.progress = 0
                
                self.isPaused = true
                self.isPaused = false
            case .stopwatch:
                return
        }
    }
    
    func handleActivityDismissed(didTapFinish: Bool) {
        didTapFinish ? self.resetTimer() : (self.isShowingActivity = true)
    }
    
    func saveFocusSesssion() {
        var totalTime: Int = 0
        
        switch self.timerCase {
            case .stopwatch:
                totalTime = self.timerSeconds
            case .timer:
                totalTime = self.totalSeconds - self.timerSeconds
            case .pomodoro(let workTime, _, _):
                if self.isAtWorkTime {
                    totalTime = (workTime * self.currentLoop) + (self.totalSeconds - self.timerSeconds)
                } else {
                    totalTime = workTime * (self.currentLoop + 1)
                }
        }
        
        self.focusSessionManager.createFocusSession(date: self.date, totalTime: totalTime, subjectID: self.subject?.unwrappedID)
        
        self.resetTimer()
    }
    
    func finishSession() {
        guard self.isShowingActivity else { return }
        
        self.saveFocusSesssion()
        self.isShowingActivity = false
    }
    
    func updateFocusSession(with focusSessionModel: FocusSessionModel) {
        self.totalSeconds = focusSessionModel.totalSeconds
        self.timerSeconds = focusSessionModel.timerSeconds
        self.timerCase = focusSessionModel.timerCase
        self.subject = focusSessionModel.subject
        self.isAtWorkTime = focusSessionModel.isAtWorkTime
        self.currentLoop = focusSessionModel.currentLoop
        self.blocksApps = focusSessionModel.blocksApps
        self.isTimeCountOn = focusSessionModel.isTimeCountOn
        self.isAlarmOn = focusSessionModel.isAlarmOn
        self.color = focusSessionModel.color
        self.workTime = focusSessionModel.workTime
        self.restTime = focusSessionModel.restTime
        self.numberOfLoops = focusSessionModel.numberOfLoops
        self.isPaused = focusSessionModel.isPaused
    }
    
    func updateAfterBackground(timeInBackground: TimeInterval, lastTimerSeconds: Int) {
        guard !self.isPaused else { return }
        
        switch self.timerCase {
            case .timer:
                break
            case .pomodoro(let workTime, let restTime, _):
                self.handlePomodoro(workTime: workTime, restTime: restTime, lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)
                self.startTimer()
            case .stopwatch:
                self.timerSeconds += Int(timeInBackground)
                
                return
        }
        
        self.updateAfterBackground = true
    }
    
    private func handlePomodoro(workTime: Int, restTime: Int, lastTimerSeconds: Int, timeInBackground: TimeInterval) {
        let totalPassedTime = self.getLoopStartTime(currentLoop: self.currentLoop, workTime: workTime, restTime: restTime) + self.getInLoopTime(workTime: workTime, restTime: restTime, isAtWorkTime: self.isAtWorkTime, timerSeconds: lastTimerSeconds) + Int(timeInBackground)
        
        self.currentLoop = self.getCurrentLoop(workTime: workTime, restTime: restTime, totalPassedTime: totalPassedTime)
        var newInLoopTime = totalPassedTime - self.getLoopStartTime(currentLoop: self.currentLoop, workTime: workTime, restTime: restTime)
        self.isAtWorkTime = newInLoopTime < workTime
        
        newInLoopTime = self.isAtWorkTime ? newInLoopTime : newInLoopTime - workTime
        
        if (self.currentLoop == self.numberOfLoops - 1 && !self.isAtWorkTime) || (self.currentLoop > self.numberOfLoops - 1) {
            // Handle timer end
        }
        
        self.totalSeconds = self.isAtWorkTime ? workTime : restTime
        
        self.pausedTime = TimeInterval(newInLoopTime)
    }
    
    private func getLoopStartTime(currentLoop: Int, workTime: Int, restTime: Int) -> Int {
        let pomodoroTotal = workTime + restTime
        return currentLoop * pomodoroTotal
    }
    
    private func getInLoopTime(workTime: Int, restTime: Int, isAtWorkTime: Bool, timerSeconds: Int) -> Int {
        return isAtWorkTime ? workTime - timerSeconds : workTime + (restTime - timerSeconds)
    }
    
    private func getCurrentLoop(workTime: Int, restTime: Int, totalPassedTime: Int) -> Int {
        let pomodoroTotal = workTime + restTime
        return totalPassedTime / pomodoroTotal
    }
}
