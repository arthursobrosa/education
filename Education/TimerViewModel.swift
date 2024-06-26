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









class TimerView: UIView{
    
    var vm = TimerViewModel(timerStart: Date(), totalTimeInMinutes: 2)
    
    private lazy var timerLabel: UILabel = {
        
//        var minutes = vm.timerValue/60
//        var seconds = vm.timerValue%60
        
        let lbl = UILabel()
//        lbl.text = String(format: "%02i:%02i", minutes, seconds)
        lbl.textAlignment = .center
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createTimer()
        vm.startTimer()
        
        vm.onChangeSecond = { [weak self] time in
            self?.timerLabel.text = String(format: "%02i:%02i", time/60, time%60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTimer(){
        self.addSubview(timerLabel)
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}

