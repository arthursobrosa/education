//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation
import Combine

class FocusSessionViewModel {
    // MARK: - FocusSession Handler
    private let focusSessionManager: FocusSessionManager
    
    private let activityManager: ActivityManager
    
    // MARK: - Combine storage
    private var cancellables = Set<AnyCancellable>()
   
    // MARK: - Properties
    var prefersStatusBarHidden = true
    
    var didTapFinish = false
    
    var pauseStatusDidChange: ((Bool) -> Void)?
    var timerSecondsDidChange: (() -> Void)?
    var timerFinishedPropertyChanged: (() -> Void)?
    var isAtWorkTimeDidChange: ((Bool) -> Void)?
    var updateAfterBackgroundPropertyDidChange: (() -> Void)?
    
    struct LayersConfig {
        let strokeEnd: CGFloat
        let isTimerTrackerShowing: Bool
        let isClockwise: Bool
        let startAngle: Double
        let endAngle: Double
    }
    
    // MARK: - Initializer
    init(focusSessionManager: FocusSessionManager = FocusSessionManager(), activityManager: ActivityManager) {
        self.focusSessionManager = focusSessionManager
        self.activityManager = activityManager
        
        activityManager.date = Date.now
        
        bindActivityManagerProperties()
    }
    
    // MARK: - Methods
    func getTimerSeconds() -> Int {
        activityManager.timerSeconds
    }
    
    func getPauseStatus() -> Bool {
        activityManager.isPaused
    }
    
    func getTimerCase() -> TimerCase {
        activityManager.timerCase
    }
    
    func getSubject() -> Subject? {
        activityManager.subject
    }
    
    func isAtWorkTime() -> Bool {
        activityManager.isAtWorkTime
    }
    
    func isTimerVisible() -> Bool {
        activityManager.isTimeCountOn
    }
    
    func isAlarmOn() -> Bool {
        activityManager.isAlarmOn
    }
    
    func hideActivityBar() {
        activityManager.isShowingActivityBar = false
    }
    
    func changeTimerVisibility() {
        activityManager.isTimeCountOn.toggle()
    }
    
    func changePauseStatus() {
        if !activityManager.isPaused {
            activityManager.isPaused = true
        }
    }
    
    func pauseResumeButtonTapped() {
        activityManager.isPaused.toggle()
        
        guard activityManager.isAtWorkTime else { return }
        
        if activityManager.isPaused {
            BlockAppsMonitor.shared.removeShields()
        } else {
            blockApps()
        }
    }
    
    func restartActivity() {
        activityManager.restartActivity()
    }
    
    func getPomodoroString() -> String {
        let number = activityManager.currentLoop + 1
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        guard let ordinalNumber = formatter.string(from: NSNumber(value: number)) else { return String() }
        
        let suffix = activityManager.isAtWorkTime ? String(localized: "focusTime") : String(localized: "pauseTime")
        
        return ordinalNumber + " " + suffix
    }
    
    func blockApps() {
        guard activityManager.blocksApps,
              !activityManager.isPaused,
              activityManager.isAtWorkTime else { return }
        
        BlockAppsMonitor.shared.applyShields()
    }
    
    func getTimerString() -> String {
        var seconds = Int()
        var minutes = Int()
        var hours = Int()
        
        let timerSeconds = activityManager.timerSeconds
        
        if timerSeconds > 0 {
            seconds = timerSeconds % 60
            minutes = timerSeconds / 60 % 60
            hours = timerSeconds / 3600
        }
        
        let secondsText = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let minutesText = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let hoursText = hours < 10 ? "0\(hours)" : "\(hours)"
        
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    
    func saveFocusSession() {
        activityManager.saveFocusSesssion()
    }
}

// MARK: - Layers configuration
extension FocusSessionViewModel {
    func getLayersConfig() -> LayersConfig {
        let strokeEnd = getStrokeEnd()
        let isTimerTrackerShowing = isTimerTrackerShowing()
        let isClockwise = isClockwise()
        let angles = getAngles()
        
        return LayersConfig(strokeEnd: strokeEnd, isTimerTrackerShowing: isTimerTrackerShowing, isClockwise: isClockwise, startAngle: angles.startAngle, endAngle: angles.endAngle)
    }
    
    func getStrokeEnd() -> CGFloat {
        activityManager.progress
    }
    
    private func isTimerTrackerShowing() -> Bool {
        guard case .stopwatch = activityManager.timerCase else {
            return true
        }
        
        return false
    }
    
    private func isClockwise() -> Bool {
        guard case .pomodoro = activityManager.timerCase else {
            return true
        }
        
        return activityManager.isAtWorkTime
    }
    
    private func getAngles() -> (startAngle: Double, endAngle: Double) {
        var startAngle = 0.0
        var endAngle = 0.0
        
        guard case .pomodoro = activityManager.timerCase else {
            startAngle = -(CGFloat.pi / 2)
            endAngle = -(CGFloat.pi / 2) + CGFloat.pi * 2
            
            return (startAngle, endAngle)
        }
        
        startAngle = activityManager.isAtWorkTime ? -(CGFloat.pi / 2) : -(CGFloat.pi / 2) + CGFloat.pi * 2
        endAngle = activityManager.isAtWorkTime ? -(CGFloat.pi / 2) + CGFloat.pi * 2 : -(CGFloat.pi / 2)
        
        return (startAngle, endAngle)
    }
}

// MARK: - Bind Activity Monitor Properties
extension FocusSessionViewModel {
    private func bindActivityManagerProperties() {
        bindPauseState()
        bindTimerSeconds()
        bindTimerFinished()
        bindIsAtWorkTime()
        bindUpdateAfterBackground()
    }
    
    private func bindPauseState() {
        activityManager.$isPaused
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPaused in
                guard let self else { return }
                
                guard case .stopwatch = activityManager.timerCase else {
                    pauseStatusDidChange?(activityManager.isPaused)
                    return
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func bindTimerSeconds() {
        activityManager.$timerSeconds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                guard !didTapFinish else { return }
                
                timerSecondsDidChange?()
            }
            .store(in: &self.cancellables)
    }
    
    private func bindTimerFinished() {
        activityManager.$timerFinished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerFinished in
                guard let self else { return }
                
                guard timerFinished else { return }
                
                timerFinishedPropertyChanged?()
            }
            .store(in: &self.cancellables)
    }
    
    private func bindIsAtWorkTime() {
        activityManager.$isAtWorkTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAtWorkTime in
                guard let self else { return }
                
                isAtWorkTimeDidChange?(isAtWorkTime)
            }
            .store(in: &self.cancellables)
    }
    
    private func bindUpdateAfterBackground() {
        activityManager.$updateAfterBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updateAfterBackground in
                guard let self else { return }
                
                guard updateAfterBackground else { return }
                
                guard case .stopwatch = activityManager.timerCase else {
                    updateAfterBackgroundPropertyDidChange?()
                    return
                }
            }
            .store(in: &self.cancellables)
    }
}
