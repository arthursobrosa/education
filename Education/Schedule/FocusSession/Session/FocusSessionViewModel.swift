//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation
import Combine

class FocusSessionViewModel {
    // MARK: - Service to manage timer and session
    let activityManager: ActivityManager
    
    // MARK: - Service to block apps
    private let blockingManager: BlockingManager
    
    // MARK: - Combine storage
    private var cancellables = Set<AnyCancellable>()
   
    // MARK: - Properties
    var prefersStatusBarHidden = true
    
    var didTapFinish = false
    
    var pauseStatusDidChange: ((Bool) -> Void)?
    var timerSecondsDidChange: (() -> Void)?
    var timerFinishedPropertyChanged: ((Bool) -> Void)?
    var isAtWorkTimeDidChange: ((Bool) -> Void)?
    var updateAfterBackgroundPropertyDidChange: (() -> Void)?
    
    // MARK: - Initializer
    init(activityManager: ActivityManager, blockingManager: BlockingManager) {
        self.activityManager = activityManager
        self.blockingManager = blockingManager
        
        activityManager.date = Date.now
        
        bindActivityManagerProperties()
    }
}

// MARK: - Bind activity manager properties to VC
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
                
                if didTapFinish {
                    self.activityManager.isPaused = true
                    return
                }
                
                timerSecondsDidChange?()
            }
            .store(in: &self.cancellables)
    }
    
    private func bindTimerFinished() {
        activityManager.$timerFinished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerFinished in
                guard let self else { return }
                
                timerFinishedPropertyChanged?(timerFinished)
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

// MARK: - Strings config
extension FocusSessionViewModel {
    // MARK: - Pomodoro
    func getPomodoroString() -> String {
        guard case .pomodoro = activityManager.timerCase else {
            return String()
        }
        
        let loop = activityManager.currentLoop + 1
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        guard let ordinalNumber = formatter.string(from: NSNumber(value: loop)) else { return String() }
        
        let suffix = activityManager.isAtWorkTime ? String(localized: "focusTime") : String(localized: "pauseTime")
        
        return ordinalNumber + " " + suffix
    }
    
    // MARK: - Timer
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
}

// MARK: - Pause/Resume button state management
extension FocusSessionViewModel {
    // MARK: - Pause/Resume button
    func changePauseStatus() {
        if !activityManager.isPaused {
            guard case .pomodoro = activityManager.timerCase,
                  !activityManager.isAtWorkTime else {
                activityManager.isPaused = true
                return
            }
        }
    }
    
    func pauseResumeButtonTapped() {
        activityManager.isPaused.toggle()
        
        guard activityManager.isAtWorkTime else { return }
        
        if activityManager.isPaused {
            unblockApps()
        } else {
            blockApps()
        }
    }
}

// MARK: - Block apps
extension FocusSessionViewModel {
    func blockApps() {
        guard activityManager.blocksApps,
              !activityManager.isPaused,
              activityManager.isAtWorkTime else { return }
        
        blockingManager.applyShields()
    }
    
    func unblockApps() {
        blockingManager.removeShields()
    }
}

// MARK: - Other auxiliar methods
extension FocusSessionViewModel {
    func shouldChangeVisibility() -> Bool {
        if (!activityManager.isPaused && prefersStatusBarHidden)
            || (activityManager.isPaused && !prefersStatusBarHidden) {
            prefersStatusBarHidden.toggle()
            return true
        }
        
        return false
    }
}

// MARK: - Extension config
extension FocusSessionViewModel {
    func getExtendedTime(hours: Int, minutes: Int) -> Int {
        hours * 3600 + minutes * 60
    }
}
