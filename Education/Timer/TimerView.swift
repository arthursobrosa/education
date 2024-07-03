//
//  TimerView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import Foundation
import UIKit

class TimerView: UIView{
    private let viewModel: TimerViewModel
    
    // MARK: - Properties
    private let timerLabel: UILabel = {
        let lbl = UILabel()
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
    
    // MARK: Initializer
    init(frame: CGRect, totalTimeInMinutes: Int, viewModel: TimerViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
    
        viewModel.startTimer()
        
        viewModel.totalTimeInMinutes = totalTimeInMinutes
        
        viewModel.onChangeSecond = { [weak self] time in
            self?.timerLabel.text = String(format: "%02i:%02i", time/60, time%60)
        }
        
        self.setupUI()
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc func togglePause(){
        viewModel.isPaused = !(viewModel.isPaused)
        print(viewModel.isPaused)
    }
    
    @objc func timerReset(){
        viewModel.timerStart = Date()
        viewModel.totalPausedTime = 0
    }
}

extension TimerView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerLabel)
        self.addSubview(timerPauseButton)
        self.addSubview(timerResetButton)
        
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
