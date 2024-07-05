//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation

class FocusSessionViewModel{
    var onChangeSecond: ((Int) -> Void)?
    
    var timer: DispatchSourceTimer?
    
    var timerStart: Date
    var totalTimeInSeconds: Int
    var timerValue: Int = 0
    var totalPausedTime: Int = 0
    var isPaused = false
    var pauseEntry: Date?
    
    
    init(timerStart: Date, totalTimeInSeconds: Int) {
        self.timerStart = timerStart
        self.totalTimeInSeconds = totalTimeInSeconds
    }
    
    func timerPause(){
        if pauseEntry == nil {
            pauseEntry = Date()
        }
    }
    
    func timerUpdate() {
        var finalTime = timerStart.timeIntervalSince1970 + Double(totalTimeInSeconds) + Double(totalPausedTime)
        
        if pauseEntry != nil {
            guard let pauseTime = pauseEntry else { return }
            let pausedTime = Date().timeIntervalSince1970 - pauseTime.timeIntervalSince1970
            totalPausedTime += Int(pausedTime.rounded(.up))
            pauseEntry = nil
            finalTime = timerStart.timeIntervalSince1970 + Double(totalTimeInSeconds) + Double(totalPausedTime)
            timerValue = Int(finalTime.rounded(.up) - Date().timeIntervalSince1970.rounded(.up))
            self.onChangeSecond?(timerValue)
        } else {
            if finalTime > Date().timeIntervalSince1970 {
                timerValue = Int(finalTime.rounded(.up) - Date().timeIntervalSince1970.rounded(.up))
            } else {
                timerValue = 0
            }
            
            self.onChangeSecond?(timerValue)
        }
    }
    
    func startTimer() {
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: 1.0)
        timer?.setEventHandler { [weak self] in
            self?.timerAction()
        }
        
        timer?.resume()
    }
    
    func timerAction() {
        DispatchQueue.main.async {
            if self.isPaused {
                self.timerPause()
            } else {
                self.timerUpdate()
            }
        }
    }
    
    deinit {
        timer?.cancel()
    }
}
