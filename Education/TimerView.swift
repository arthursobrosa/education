//
//  TimerView.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class TimerView: UIView{
    
    private lazy var timerLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .label
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
     init(frame: CGRect, totalTimeInMinutes: Int) {
        super.init(frame: frame)
        
         let vm = TimerViewModel(timerStart: Date(), totalTimeInMinutes: totalTimeInMinutes)
         
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

