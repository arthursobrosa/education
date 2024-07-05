//
//  FocusSessionView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionView: UIView {
    private let viewModel: FocusSessionViewModel
    
    // MARK: - Properties
    let timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 50)
        lbl.textColor = .label
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timerTrackLayer = CAShapeLayer()
    private let timerCircleFillLayer = CAShapeLayer()
    
    func setupLayers() {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: self.timerLabel.frame.height / 2, y: self.timerLabel.frame.width / 2), radius: self.timerLabel.frame.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
    }
    
    // MARK: Initializer
    init(frame: CGRect, viewModel: FocusSessionViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
    
        viewModel.startTimer()
        
        self.setupUI()
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc func togglePause() {
        viewModel.isPaused = !(viewModel.isPaused)
    }
    
    @objc func timerReset() {
        viewModel.timerStart = Date()
        viewModel.totalPausedTime = 0
    }
}

extension FocusSessionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
