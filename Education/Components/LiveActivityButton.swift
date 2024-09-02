//
//  LiveActivityButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 01/09/24.
//

import UIKit

class LiveActivityButton: UIButton {
    private let color: UIColor?
    private let progress: CGFloat
    
    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)), for: .normal)
        button.tintColor = self.color
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let timerTrackLayer = CAShapeLayer()
    private let timerCircleFillLayer = CAShapeLayer()
    
    init(color: UIColor?, progress: CGFloat) {
        self.color = color
        self.progress = progress
        
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupLayers()
    }
}

private extension LiveActivityButton {
    func setupUI() {
        self.addSubview(timerContainerView)
        timerContainerView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            timerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            timerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            timerContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            playButton.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor),
            playButton.heightAnchor.constraint(equalTo: timerContainerView.heightAnchor),
            playButton.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor)
        ])
    }
    
    private func setupLayers() {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: self.frame.width / 2, startAngle: -(CGFloat.pi / 2), endAngle: -(CGFloat.pi / 2) + CGFloat.pi * 2, clockwise: true)
        
        let lineWidth = self.bounds.width * (4/44)
        
        self.timerTrackLayer.path = arcPath.cgPath
        self.timerTrackLayer.strokeColor = UIColor.systemGray5.cgColor
        self.timerTrackLayer.lineWidth = lineWidth
        self.timerTrackLayer.fillColor = UIColor.clear.cgColor
        self.timerTrackLayer.lineCap = .round
        self.timerTrackLayer.strokeEnd = 1
        
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = self.color?.cgColor
        self.timerCircleFillLayer.lineWidth = lineWidth
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = self.progress
        
        self.playButton.layer.addSublayer(timerTrackLayer)
        self.playButton.layer.addSublayer(timerCircleFillLayer)
        
        self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
    }
}
