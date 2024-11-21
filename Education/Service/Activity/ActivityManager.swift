//
//  ActivityManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/08/24.
//

import ActivityKit
import UIKit

enum TimerCase: Equatable {
    case stopwatch
    case timer
    case pomodoro(workTime: Int, restTime: Int, numberOfLoops: Int)
    
    static func == (lhs: TimerCase, rhs: TimerCase) -> Bool {
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
    
    var text: String {
        switch self {
        case .timer:
            String(localized: "timerSelectionBold")
        case .pomodoro:
            String(localized: "pomodoroSelectionTitle")
        case .stopwatch:
            String(localized: "stopwatchSelectionBold")
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
    func isTimerTrackerShowing() -> Bool
    func isClockwise() -> Bool
    func getAngles() -> (startAngle: Double, endAngle: Double)
    func getLayersConfig() -> ActivityManager.LayersConfig
    func computeExtendedTime()
    func resetToOriginalConfig()
    func resetPomodoro()
    func isLastPomodoro() -> Bool
    func continuePomodoro()
    func extendTimer(in seconds: Int)
    func updatePomodoroAfterExtension(seconds: Int)
}

protocol SessionManaging {
    func handleDismissedActivity(didTapFinish: Bool)
    func saveFocusSesssion(withNotes notes: String)
    func computeTimerTotalTime()
    func computePomodoroTotalTime()
    func finishSession()
    func updateFocusSession(with focusSessionModel: FocusSessionModel)
    func restartActivity()
    func getLoopStartTime() -> Int
    func getInLoopTime(lastTimerSeconds: Int) -> Int
    func getCurrentLoop(totalPassedTime: Int) -> Int
    func handlePomodoro(lastTimerSeconds: Int, timeInBackground: TimeInterval)
    func updateAfterBackground(timeInBackground: TimeInterval, lastTimerSeconds: Int)
}

protocol TimerAnimation {
    var timerTrackLayer: CAShapeLayer { get set }
    var timerCircleFillLayer: CAShapeLayer { get set }
    var timerAnimation: CABasicAnimation { get set }
    
    func startAnimation(timerDuration: Double)
    func resetAnimations()
    func redefineAnimation(timerDuration: Double, strokeEnd: CGFloat)
}

extension TimerAnimation {
    func startAnimation(timerDuration: Double) {
        timerAnimation.duration = timerDuration
        timerCircleFillLayer.add(timerAnimation, forKey: "timerEnd")
    }
    
    func resetAnimations() {
        timerCircleFillLayer.removeAllAnimations()
    }
    
    func redefineAnimation(timerDuration: Double, strokeEnd: CGFloat) {
        timerCircleFillLayer.strokeEnd = strokeEnd
        timerAnimation.duration = timerDuration
    }
}

class ActivityManager {
    // MARK: - Delegate to connect with TabBar
    
    weak var delegate: TabBarDelegate?
    
    // MARK: - FocusSession and Schedule Managers
    
    private let focusSessionManager: FocusSessionManager
    private let scheduleManager: ScheduleManager
    
    // MARK: - Notification Service
    
    private let notificationService: NotificationServiceProtocol?
    
    // MARK: - Live Activity
    
    private var liveActivity: Activity<TimerAttributes>?
    
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
            if isPaused {
                stopTimer()
                endLiveActivity()
            } else {
                startTimer()
            }
        }
    }
    
    @Published var updateAfterBackground: Bool = false
    
    var isShowingActivityBar: Bool = false {
        didSet {
            if isShowingActivityBar {
                if case .pomodoro = timerCase,
                   !isAtWorkTime {
                    isProgressingActivityBar = true
                }
                
                delegate?.addActivityView()
                
                return
            }
            
            delegate?.removeActivityView()
        }
    }
    
    struct LayersConfig {
        let strokeEnd: CGFloat
        let isTimerTrackerShowing: Bool
        let isClockwise: Bool
        let startAngle: Double
        let endAngle: Double
    }
    
    var isProgressingActivityBar = false
    
    var totalTime = 0
    var isExtending = false
    var extendedTime = 0
    var originalTime = 0
    
    // MARK: - Schedule properties
    
    var date: Date
    
    var scheduleID: String?
    var subject: Subject?
    var blocksApps: Bool
    var isTimeCountOn: Bool
    var isAlarmOn: Bool
    
    var color: UIColor?
    
    // MARK: - Initializer
    
    init(focusSessionManager: FocusSessionManager = FocusSessionManager(),
         notificationService: NotificationServiceProtocol?,
         scheduleManager: ScheduleManager = ScheduleManager(),
         timerCase: TimerCase = .timer,
         totalSeconds: Int = 1,
         timerSeconds: Int = 1,
         isPaused: Bool = true,
         date: Date = Date(),
         scheduleID: String? = nil,
         subject: Subject? = nil,
         blocksApps: Bool = false,
         isTimeCountOn: Bool = true,
         isAlarmOn: Bool = false,
         color: UIColor? = nil) {
        
        self.focusSessionManager = focusSessionManager
        self.scheduleManager = scheduleManager
        self.notificationService = notificationService
        
        self.timerCase = timerCase
        self.totalSeconds = totalSeconds
        self.timerSeconds = timerSeconds
        self.isPaused = isPaused
        
        self.date = date
        self.scheduleID = scheduleID
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
        startLiveActivity(restTime: !isAtWorkTime)
        
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
        self.timer?.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            let elapsed = currentDate().timeIntervalSince(self.startTime ?? currentDate())
            self.progress = CGFloat(min(elapsed / Double(self.totalSeconds), 1))
            
            let remainingTime = max(self.totalSeconds - Int(elapsed), 0)
            self.timerSeconds = remainingTime
            self.updateLiveActivity(timerCase: timerCase)
            
            if isProgressingActivityBar {
                delegate?.updateTimerSeconds()
            }
            
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
        progress = 0
        
        self.timer = timer
        self.timer?.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            self.timerSeconds += 1
            self.updateLiveActivity(timerCase: timerCase)
        }
    }
    
    func stopTimer(currentDate: () -> Date = Date.init) {
        timer?.invalidate()
        timer = nil
        
        switch timerCase {
        case .timer, .pomodoro:
            notificationService?.cancelNotificationByName(name: subject?.unwrappedName)
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
        isExtending = false
        isProgressingActivityBar = false
        extendedTime = 0
        originalTime = 0
        
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
        if isProgressingActivityBar {
            delegate?.activityViewTapped()
            timerFinished = true
            return
        }
        
        switch timerCase {
        case .timer, .pomodoro:
            stopTimer()
            endLiveActivity()
            timerFinished = true
            
            if isExtending {
                computeExtendedTime()
                isExtending = false
            }
        case .stopwatch:
            return
        }
    }
    
    func isTimerTrackerShowing() -> Bool {
        guard case .stopwatch = timerCase else {
            return true
        }
        
        return false
    }
    
    func isClockwise() -> Bool {
        guard case .pomodoro = timerCase else {
            return true
        }
        
        if isProgressingActivityBar {
            return false
        }
        
        return isAtWorkTime
    }
    
    func getAngles() -> (startAngle: Double, endAngle: Double) {
        var startAngle = 0.0
        var endAngle = 0.0
        
        guard case .pomodoro = timerCase else {
            startAngle = -(CGFloat.pi / 2)
            endAngle = -(CGFloat.pi / 2) + CGFloat.pi * 2
            
            return (startAngle, endAngle)
        }
        
        startAngle = isAtWorkTime ? -(CGFloat.pi / 2) : -(CGFloat.pi / 2) + CGFloat.pi * 2
        endAngle = isAtWorkTime ? -(CGFloat.pi / 2) + CGFloat.pi * 2 : -(CGFloat.pi / 2)
        
        return (startAngle, endAngle)
    }
    
    func getLayersConfig() -> LayersConfig {
        let strokeEnd = progress
        let isTimerTrackerShowing = isTimerTrackerShowing()
        let isClockwise = isClockwise()
        let angles = getAngles()
        
        return LayersConfig(strokeEnd: strokeEnd, isTimerTrackerShowing: isTimerTrackerShowing, isClockwise: isClockwise, startAngle: angles.startAngle, endAngle: angles.endAngle)
    }
    
    func computeExtendedTime() {
        switch timerCase {
        case .timer:
            extendedTime += totalSeconds
        case .pomodoro:
            if isAtWorkTime {
                extendedTime += totalSeconds
            }
        case .stopwatch:
            return
        }
        
        resetToOriginalConfig()
    }
    
    func resetToOriginalConfig() {
        switch timerCase {
        case .timer:
            totalSeconds = originalTime
        case .pomodoro:
            resetPomodoro()
        case .stopwatch:
            return
        }
    }
    
    func resetPomodoro() {
        if isAtWorkTime {
            workTime = originalTime
        } else {
            restTime = originalTime
        }
        
        timerCase = .pomodoro(workTime: workTime, restTime: restTime, numberOfLoops: numberOfLoops)
    }
    
    func isLastPomodoro() -> Bool {
        guard isAtWorkTime,
              currentLoop >= numberOfLoops - 1
        else {
            return false
        }
        
        return true
    }
    
    func continuePomodoro() {
        guard !isLastPomodoro() else { return }
        
        timerFinished = false
        
        if isAtWorkTime {
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
    }
    
    func extendTimer(in seconds: Int) {
        timerFinished = false
        isExtending = true
        
        let currentFocusSession = FocusSessionModel(
            date: date,
            totalSeconds: seconds,
            timerSeconds: seconds,
            timerCase: timerCase,
            scheduleID: scheduleID,
            subject: subject,
            isAtWorkTime: isAtWorkTime,
            blocksApps: blocksApps,
            isTimeCountOn: isTimeCountOn,
            isAlarmOn: isAlarmOn
        )
        currentFocusSession.currentLoop = currentLoop
        currentFocusSession.color = color
        currentFocusSession.workTime = workTime
        currentFocusSession.restTime = restTime
        currentFocusSession.numberOfLoops = numberOfLoops
        
        progress = 0
        pausedTime = 0
        startTime = nil
        
        updateFocusSession(with: currentFocusSession)
        
        isPaused = true
        isPaused = false
    }
    
    func updatePomodoroAfterExtension(seconds: Int) {
        guard case .pomodoro = timerCase else { return }
        
        if isAtWorkTime {
            workTime = seconds
        } else {
            restTime = seconds
        }
        
        timerCase = .pomodoro(workTime: workTime, restTime: restTime, numberOfLoops: numberOfLoops)
    }
}

// MARK: - Session Management

extension ActivityManager: SessionManaging {
    func handleDismissedActivity(didTapFinish: Bool) {
        didTapFinish ? resetTimer() : (isShowingActivityBar = true)
    }

    func saveFocusSesssion(withNotes notes: String = String()) {
        var timerCaseValue: Int
        
        switch timerCase {
        case .timer:
            timerCaseValue = 0
        case .pomodoro:
            timerCaseValue = 1
        case .stopwatch:
            timerCaseValue = 2
        }
        
        focusSessionManager.createFocusSession(
            date: date,
            totalTime: totalTime,
            subjectID: subject?.unwrappedID,
            timerCase: timerCaseValue,
            notes: notes
        )
        
        let weekday = Calendar.current.component(.weekday, from: Date()) - 1
        
        if let scheduleID,
           let schedule = scheduleManager.fetchSchedule(from: scheduleID),
           schedule.unwrappedDay == weekday {
            
            schedule.completed = true
            schedule.completionDate = Date()
            scheduleManager.updateSchedule(schedule)
        }
    }
    
    func computeTotalTime() {
        switch timerCase {
        case .stopwatch:
            totalTime = timerSeconds
        case .timer:
            computeTimerTotalTime()
        case .pomodoro:
            computePomodoroTotalTime()
        }
    }
    
    func computeTimerTotalTime() {
        guard case .timer = timerCase else { return }
        
        if isExtending {
            extendedTime += totalSeconds - timerSeconds
            totalTime = originalTime + extendedTime
        } else {
            totalTime = totalSeconds - timerSeconds + extendedTime
        }
    }
    
    func computePomodoroTotalTime() {
        guard case .pomodoro = timerCase else { return }
        
        if isExtending {
            if isAtWorkTime {
                extendedTime += workTime - timerSeconds
                totalTime = originalTime * (currentLoop + 1)
            } else {
                totalTime = workTime * (currentLoop + 1)
            }
        } else {
            if isAtWorkTime {
                totalTime = (workTime * currentLoop) + (workTime - timerSeconds)
            } else {
                totalTime = workTime * (currentLoop + 1)
            }
        }
        
        totalTime += extendedTime
    }
    
    func finishSession() {
        guard isShowingActivityBar else { return }
        
        saveFocusSesssion()
        resetTimer()
        isShowingActivityBar = false
    }
    
    func updateFocusSession(with focusSessionModel: FocusSessionModel) {
        totalSeconds = focusSessionModel.totalSeconds
        timerSeconds = focusSessionModel.timerSeconds
        timerCase = focusSessionModel.timerCase
        scheduleID = focusSessionModel.scheduleID
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
    }
    
    func restartActivity() {
        timerFinished = false
        
        let currentFocusSession = FocusSessionModel(
            date: date,
            totalSeconds: totalSeconds,
            timerSeconds: totalSeconds,
            timerCase: timerCase,
            scheduleID: scheduleID,
            subject: subject,
            isAtWorkTime: isAtWorkTime,
            blocksApps: blocksApps,
            isTimeCountOn: isTimeCountOn,
            isAlarmOn: isAlarmOn
        )
        currentFocusSession.currentLoop = currentLoop
        currentFocusSession.color = color
        currentFocusSession.workTime = workTime
        currentFocusSession.restTime = restTime
        currentFocusSession.numberOfLoops = numberOfLoops
        
        progress = 0
        pausedTime = 0
        startTime = nil
        
        updateFocusSession(with: currentFocusSession)
        
        isPaused = true
        isPaused = false
    }
    
    func getLoopStartTime() -> Int {
        var pomodoroTotal = 0
        
        if isExtending {
            if isAtWorkTime {
                pomodoroTotal = originalTime + restTime
            } else {
                pomodoroTotal = workTime + originalTime
            }
        } else {
            pomodoroTotal = workTime + restTime
        }
        
        return currentLoop * pomodoroTotal
    }
    
    func getInLoopTime(lastTimerSeconds: Int) -> Int {
        if isExtending {
            if isAtWorkTime {
                return originalTime + (workTime - lastTimerSeconds)
            } else {
                return workTime + originalTime + (restTime - lastTimerSeconds)
            }
        } else {
            return isAtWorkTime ? workTime - lastTimerSeconds : workTime + (restTime - lastTimerSeconds)
        }
    }
    
    func getCurrentLoop(totalPassedTime: Int) -> Int {
        let pomodoroTotal = workTime + restTime
        return totalPassedTime / pomodoroTotal
    }
    
    func handlePomodoro(lastTimerSeconds: Int, timeInBackground: TimeInterval) {
        var totalPassedTime = getLoopStartTime() + getInLoopTime(lastTimerSeconds: lastTimerSeconds) + Int(timeInBackground)
        
        if isExtending {
            if Int(timeInBackground) >= lastTimerSeconds {
                totalPassedTime -= isAtWorkTime ? workTime : restTime
                computeExtendedTime()
                isExtending = false
                currentLoop = getCurrentLoop(totalPassedTime: totalPassedTime)
            } else {
                pausedTime = timeInBackground
                return
            }
        } else {
            currentLoop = getCurrentLoop(totalPassedTime: totalPassedTime)
        }
        
        var newInLoopTime = totalPassedTime - getLoopStartTime()
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
    
    func updateAfterBackground(timeInBackground: TimeInterval, lastTimerSeconds: Int) {
        guard !isPaused else { return }
        
        switch timerCase {
        case .timer:
            break
        case .pomodoro:
            handlePomodoro(lastTimerSeconds: lastTimerSeconds, timeInBackground: timeInBackground)
            startTimer()
        case .stopwatch:
            timerSeconds += Int(timeInBackground)
            
            return
        }
        
        updateAfterBackground = true
    }
}

extension ActivityManager {
    func startLiveActivity(restTime: Bool) {
        let duration: Int
        
        switch timerCase {
        case .timer:
            duration = timerSeconds
        case .pomodoro:
            duration = timerSeconds
        case .stopwatch:
            // TODO: - Change this
            duration = timerSeconds
        }
        
        liveActivity = LiveActivityManager().startActivity(duration: duration,
                                                           progress: progress,
                                                           title: subject?.unwrappedName ?? String(localized: "immediateActivity"),
                                                           color: subject?.unwrappedColor ?? "redPicker",
                                                           restTime: restTime)
    }
    
    func updateLiveActivity(timerCase: TimerCase) {
        guard let id = liveActivity?.id else { return }
        
        let duration = timerSeconds
        
        LiveActivityManager().updateActivity(
            activity: id,
            duration: duration,
            progress: progress
        )
    }
    
    func endLiveActivity() {
        LiveActivityManager().endActivity(timerCase: timerCase)
    }
}
