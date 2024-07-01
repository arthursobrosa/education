//
//  TimerView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import Foundation
import UIKit

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
    
    private lazy var timerPauseButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("pause", for: .normal)
        btn.addTarget(self, action: #selector(togglePause), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .blue
        
        return btn
    }()
    
    private lazy var timerResetButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("reset", for: .normal)
        btn.addTarget(self, action: #selector(timerReset), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        
        return btn
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
        self.addSubview(timerPauseButton)
        self.addSubview(timerResetButton)
        setConstraints()
    }
    
    @objc func togglePause(){
        vm.isPaused = !(vm.isPaused)
        print(vm.isPaused)
    }
    
    @objc func timerReset(){
        vm.timerStart = Date()
        vm.totalPausedTime = 0
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            timerPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            timerPauseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerPauseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            timerResetButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerResetButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 100),
            timerResetButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerResetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
