//
//  TimerViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation
import UIKit

class TimerViewModel{
    var onChangeSecond: ((Int) -> Void)?
    
    var timer: DispatchSourceTimer?
    
    var timerStart: Date
    var totalTimeInMinutes: Int
    var timerValue: Int = 0
    var totalPausedTime: Int = 0
    var isPaused = false
    
    init(timerStart: Date, totalTimeInMinutes: Int) {
        self.timerStart = timerStart
        self.totalTimeInMinutes = totalTimeInMinutes
    }
    
    func timerReset(){
        timerStart = Date()
    }
    
    func timerPause(){
        totalPausedTime += 1
        print(totalPausedTime)
    }
    
    func timerUpdate(){
        let finalTime = timerStart.timeIntervalSince1970 + Double(totalTimeInMinutes * 60) + Double(totalPausedTime)
        if(finalTime > Date().timeIntervalSince1970){
            timerValue = Int(finalTime - Date().timeIntervalSince1970)
        }
        else{
            timerValue = 0
        }
        
        print(timerValue)
        self.onChangeSecond?(timerValue)
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
                if(self.isPaused){
                    self.timerPause()
                }else{
                    self.timerUpdate()
                }
            }
        }
        
        deinit {
            timer?.cancel()
        }
    
//    func addObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(activeAgain), name: UIApplication.didBecomeActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(goingAway), name: UIApplication.didEnterBackgroundNotification, object: nil)
//    }
//    
//    
//    @objc func activeAgain() {
//        print("Saiu do background")
//    }
//    
//    @objc func goingAway() {
//        print("Entrou em background")
//    }
}
