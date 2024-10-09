//
//  ActivityManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/08/24.
//

import UIKit

enum TimerCase: Equatable {
    case stopwatch
    case timer
    case pomodoro(workTime: Int, restTime: Int, numberOfLoops: Int)
    
    static func ==(lhs: TimerCase, rhs: TimerCase) -> Bool {
        switch (lhs, rhs) {
            case (.stopwatch, .stopwatch),
                 (.timer, .timer):
                return true
            case let (.pomodoro(workTime1, restTime1, numberOfLoops1),
                      .pomodoro(workTime2, restTime2, numberOfLoops2)):
                return workTime1 == workTime2 &&
                       restTime1 == restTime2 &&
                       numberOfLoops1 == numberOfLoops2
            default:
                return false
        }
    }
}

protocol TimerProtocol {
    func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void)
    func invalidate()
}

class TimerWrapper: TimerProtocol {
    private var timer: Timer?
    
    func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
}

protocol TimerManaging {
    func startTimer(timer: TimerProtocol, currentDate: @escaping () -> Date)
    func startStopwatch(timer: TimerProtocol)
    func stopTimer(currentDate: () -> Date)
    func resetTimer()
    func handleTimerEnd()
}

protocol SessionManaging {
    func saveFocusSesssion()
    func finishSession()
    func updateFocusSession(with focusSessionModel: FocusSessionModel)
    func restartActivity()
    func handleDismissedActivity(didTapFinish: Bool)
    func updateAfterBackground(timeInBackground: TimeInterval, lastTimerSeconds: Int)
    func handlePomodoro(workTime: Int, restTime: Int, lastTimerSeconds: Int, timeInBackground: TimeInterval)
    func getLoopStartTime(currentLoop: Int, workTime: Int, restTime: Int) -> Int
    func getInLoopTime(workTime: Int, restTime: Int, isAtWorkTime: Bool, timerSeconds: Int) -> Int
    func getCurrentLoop(workTime: Int, restTime: Int, totalPassedTime: Int) -> Int
}

class ActivityManager {
    // MARK: - Delegate and FocusSession manager
    weak var delegate: TabBarDelegate?
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Timer properties
    var timerCase: TimerCase
    
    var startTime: Date?
    var pausedTime: TimeInterval = 0
    var timer: TimerProtocol?
    
    @Published var timerFinished: Bool = false
    
    var totalSeconds: Int
    @Published var timerSeconds: Int
    
    @Published var isAtWorkTime: Bool = true
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
    
    var isShowingActivityBar: Bool = false {
        didSet {
            if isShowingActivityBar {
                self.delegate?.addActivityView()
                
                return
            }
            
            self.delegate?.removeActivityView()
        }
    }
    
    var totalTime = 0
    
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
}

// MARK: - Timer Management
extension ActivityManager: TimerManaging {
    func startTimer(timer: TimerProtocol = TimerWrapper(), currentDate: @escaping () -> Date = Date.init) {
        switch timerCase {
            case .stopwatch:
                startStopwatch()
                return
            default:
                break
        }
        
        if startTime == nil {
            startTime = currentDate()
        } else {
            startTime = currentDate().addingTimeInterval(-pausedTime)
        }
            
        self.timer = timer
        self.timer?.scheduledTimer(withTimeInterval: 1/60, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            let elapsed = currentDate().timeIntervalSince(self.startTime ?? currentDate())
            self.progress = CGFloat(min(elapsed / Double(self.totalSeconds), 1))
            
            let remainingTime = max(self.totalSeconds - Int(elapsed), 0)
            self.timerSeconds = remainingTime
            
            if elapsed >= Double(self.totalSeconds) {
                self.handleTimerEnd()
            }
            
            if self.updateAfterBackground {
                self.updateAfterBackground = true
                self.updateAfterBackground = false
            }
        }
    }
    
    func startStopwatch(timer: TimerProtocol = TimerWrapper()) {
        self.progress = 0
        
        self.timer = timer
        self.timer?.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.timerSeconds += 1
        }
    }
    
    func stopTimer(currentDate: () -> Date = Date.init) {
        timer?.invalidate()
        timer = nil
        
        switch timerCase {
            case .timer, .pomodoro:
                NotificationService.shared.cancelNotificationByName(name: subject?.unwrappedName)
            default:
                break
        }
        
        if let startTime = startTime {
            pausedTime = currentDate().timeIntervalSince(startTime)
        }
    }
    
    func resetTimer() {
        isPaused = true
        
        timerFinished = false
        
        progress = 0
        totalSeconds = 0
        timerSeconds = 0
        pausedTime = 0
        startTime = nil
        
        isAtWorkTime = true
        workTime = 0
        restTime = 0
        numberOfLoops = 0
        currentLoop = 0
    }
    
    func handleTimerEnd() {
        switch timerCase {
            case .timer:
                stopTimer()
                timerFinished = true
                
                return
            case .pomodoro:
                if isAtWorkTime {
                    if currentLoop >= numberOfLoops - 1 {
                        stopTimer()
                        timerFinished = true
                        
                        return
                    }
                    
                    isAtWorkTime.toggle()
                    totalSeconds = restTime
                    timerSeconds = totalSeconds
                } else {
                    currentLoop += 1
                    isAtWorkTime.toggle()
                    totalSeconds = workTime
                    timerSeconds = totalSeconds
                }
                
                startTime = nil
                pausedTime = 0
                progress = 0
                
                isPaused = true
                isPaused = false
            case .stopwatch:
                return
        }
    }
}

// MARK: - Session Management
extension ActivityManager: SessionManaging {
    func handleDismissedActivity(didTapFinish: Bool) {
        didTapFinish ? resetTimer() : (isShowingActivityBar = true)
    }
    
    func saveFocusSesssion() {
        totalTime = 0
        
        switch timerCase {
            case .stopwatch:
                totalTime = timerSeconds
            case .timer:
                totalTime = totalSeconds - timerSeconds
            case .pomodoro(let workTime, _, _):
                if isAtWorkTime {
                    totalTime = (workTime * currentLoop) + (totalSeconds - timerSeconds)
                } else {
                    totalTime = workTime * (currentLoop + 1)
                }
        }
        
        focusSessionManager.createFocusSession(date: date, totalTime: totalTime, subjectID: self.subject?.unwrappedID)
        
        resetTimer()
    }
    
    func finishSession() {
        guard isShowingActivityBar else { return }
        
        saveFocusSesssion()
        isShowingActivityBar = false
    }
    
    func updateFocusSession(with focusSessionModel: FocusSessionModel) {
        totalSeconds = focusSessionModel.totalSeconds
        timerSeconds = focusSessionModel.timerSeconds
        timerCase = focusSessionModel.timerCase
        subject = focusSessionModel.subject
        isAtWorkTime = focusSessionModel.isAtWorkTime
        currentLoop = focusSessionModel.currentLoop
        blocksApps = focusSessionModel.blocksApps
        isTimeCountOn = focusSessionModel.isTimeCountOn
        isAlarmOn = focusSessionModel.isAlarmOn
        color = focusSessionModel.color
        workTime = focusSessionModel.workTime
        restTime = focusSessionModel.restTime
        numberOfLoops = focusSessionModel.numberOfLoops
        isPaused = false
    }
    
    func restartActivity() {
        let currentFocusSession = FocusSessionModel(date: date, totalSeconds: totalSeconds, timerSeconds: totalSeconds, timerCase: timerCase, subject: subject, isAtWorkTime: true, blocksApps: blocksApps, isTimeCountOn: isTimeCountOn, isAlarmOn: isAlarmOn)
        currentFocusSession.currentLoop = 0
        currentFocusSession.color = color
        currentFocusSession.workTime = workTime
        currentFocusSession.restTime = restTime
        currentFocusSession.numberOfLoops = numberOfLoops
        
        resetTimer()
        
        updateFocusSession(with: currentFocusSession)
        
        isPaused = true
        isPaused = false
    }
    
    func updateAfterBackground(timeInBackground: TimeInterval, lastTimerSeconds: Int) {
        guard !isPaused else { return }
        
        switch timerCase {
            case .timer:
                break
            case .pomodoro(let workTime, let restTime, _):
                handlePomodoro(workTime: workTime, restTime: restTime, lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)
                startTimer()
            case .stopwatch:
                timerSeconds += Int(timeInBackground)
                
                return
        }
        
        updateAfterBackground = true
    }
    
    func handlePomodoro(workTime: Int, restTime: Int, lastTimerSeconds: Int, timeInBackground: TimeInterval) {
        let totalPassedTime = getLoopStartTime(currentLoop: currentLoop, workTime: workTime, restTime: restTime) + getInLoopTime(workTime: workTime, restTime: restTime, isAtWorkTime: isAtWorkTime, timerSeconds: lastTimerSeconds) + Int(timeInBackground)
        
        currentLoop = getCurrentLoop(workTime: workTime, restTime: restTime, totalPassedTime: totalPassedTime)
        var newInLoopTime = totalPassedTime - getLoopStartTime(currentLoop: currentLoop, workTime: workTime, restTime: restTime)
        isAtWorkTime = newInLoopTime < workTime
        
        newInLoopTime = isAtWorkTime ? newInLoopTime : newInLoopTime - workTime
        
        if (currentLoop == numberOfLoops - 1 && !isAtWorkTime) || (currentLoop > numberOfLoops - 1) {
            isAtWorkTime = true
            handleTimerEnd()
            return
        }
        
        totalSeconds = isAtWorkTime ? workTime : restTime
        
        pausedTime = TimeInterval(newInLoopTime)
    }
    
    func getLoopStartTime(currentLoop: Int, workTime: Int, restTime: Int) -> Int {
        let pomodoroTotal = workTime + restTime
        return currentLoop * pomodoroTotal
    }
    
    func getInLoopTime(workTime: Int, restTime: Int, isAtWorkTime: Bool, timerSeconds: Int) -> Int {
        return isAtWorkTime ? workTime - timerSeconds : workTime + (restTime - timerSeconds)
    }
    
    func getCurrentLoop(workTime: Int, restTime: Int, totalPassedTime: Int) -> Int {
        let pomodoroTotal = workTime + restTime
        return totalPassedTime / pomodoroTotal
    }
}
