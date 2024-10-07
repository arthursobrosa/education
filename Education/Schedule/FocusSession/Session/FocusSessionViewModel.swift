//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation

class FocusSessionViewModel {
    // MARK: - FocusSession Handler
    private let focusSessionManager: FocusSessionManager
    
//    private let activityManager: ActivityManager
   
    // MARK: - Properties
    var prefersStatusBarHidden = true
    
    var didTapFinish = false
    
    // MARK: - Initializer
    init(focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.focusSessionManager = focusSessionManager
        
        ActivityManager.shared.date = Date.now
    }
    
    // MARK: - Methods
    func getStrokeEnd() -> CGFloat {
        return ActivityManager.shared.progress
    }
    
    func getTimerString() -> String {
        var seconds = Int()
        var minutes = Int()
        var hours = Int()
        
        let timerSeconds = ActivityManager.shared.timerSeconds
        
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
        ActivityManager.shared.saveFocusSesssion()
    }
}
