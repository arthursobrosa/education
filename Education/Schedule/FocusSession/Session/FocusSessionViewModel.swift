//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import ActivityKit
import Combine
import Foundation

class FocusSessionViewModel {
    // MARK: - Service to manage timer and session

    let activityManager: ActivityManager
    
    // MARK: - Service to block apps

    private let blockingManager: BlockingManager
    
    // MARK: - Service to play sounds
    
    private let audioService: AudioServiceProtocol

    // MARK: - Combine storage

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Properties

    var prefersStatusBarHidden = true

    var didTapFinish = false

    var pauseStatusDidChange: ((Bool) -> Void)?
    var timerSecondsDidChange: (() -> Void)?
    var timerFinishedPropertyChanged: ((Bool) -> Void)?
    var isAtWorkTimeDidChange: ((Bool) -> Void)?
    var updatePropertyDidChange: (() -> Void)?

    // MARK: - Initializer

    init(activityManager: ActivityManager, blockingManager: BlockingManager, audioServiceProtocol: AudioServiceProtocol = AudioService()) {
        self.activityManager = activityManager
        self.blockingManager = blockingManager
        self.audioService = audioServiceProtocol

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
            .sink { [weak self] _ in
                guard let self else { return }

                guard case .stopwatch = activityManager.timerCase else {
                    pauseStatusDidChange?(activityManager.isPaused)
                    return
                }
            }
            .store(in: &cancellables)
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
            .store(in: &cancellables)
    }

    private func bindTimerFinished() {
        activityManager.$timerFinished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timerFinished in
                guard let self else { return }

                timerFinishedPropertyChanged?(timerFinished)
            }
            .store(in: &cancellables)
    }

    private func bindIsAtWorkTime() {
        activityManager.$isAtWorkTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAtWorkTime in
                guard let self else { return }

                isAtWorkTimeDidChange?(isAtWorkTime)
            }
            .store(in: &cancellables)
    }

    private func bindUpdateAfterBackground() {
        activityManager.$updateAfterBackground
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updateAfterBackground in
                guard let self else { return }

                guard updateAfterBackground else { return }

                guard case .stopwatch = activityManager.timerCase else {
                    updatePropertyDidChange?()
                    return
                }
            }
            .store(in: &cancellables)
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
    
    // MARK: - Title
    
    func getFormatterSubjectName() -> String? {
        guard let subject = activityManager.subject else { return nil }
        
        let maxLength = 22
        var subjectName = subject.unwrappedName
        if subjectName.count > maxLength {
            subjectName = String(subjectName.prefix(maxLength)) + "..."
        }
        return subjectName
    }
}

// MARK: - Pause/Resume button state management

extension FocusSessionViewModel {
    // MARK: - Pause/Resume button
    
    func changePauseStatus() {
        if !activityManager.isPaused {
            guard case .pomodoro = activityManager.timerCase,
                  !activityManager.isAtWorkTime
            else {
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

// MARK: - Audio Service methods

extension FocusSessionViewModel {
    func playAlarm() {
        guard activityManager.isAlarmOn else { return }
        
        audioService.playSound(.alarm)
    }
    
    func stopAlarm() {
        guard activityManager.isAlarmOn else { return }
        
        audioService.stopSound(.alarm)
    }
}
