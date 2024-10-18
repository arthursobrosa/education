//
//  ActivityBarButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 01/09/24.
//

import UIKit

class ActivityBarButton: UIButton {
    // MARK: - Properties
    private let color: UIColor?
    private let progress: CGFloat
    
    // MARK: - UI Properties
    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var pauseResumeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        button.tintColor = color
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let timerTrackLayer = CAShapeLayer()
    private let timerCircleFillLayer = CAShapeLayer()
    
    // MARK: - Initializer
    init(color: UIColor?, progress: CGFloat) {
        self.color = color
        self.progress = progress
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayers()
    }
    
    func updatePauseResumeButton(isPaused: Bool) {
        let imageName = isPaused ? "play.fill" : "pause.fill"
        
        UIView.transition(with: pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            guard let self else { return }
            
            self.pauseResumeButton.setImage(UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        }
    }
}

// MARK: - UI Setup
extension ActivityBarButton: ViewCodeProtocol {
    func setupUI() {
        addSubview(timerContainerView)
        timerContainerView.addSubview(pauseResumeButton)
        
        NSLayoutConstraint.activate([
            timerContainerView.widthAnchor.constraint(equalTo: widthAnchor),
            timerContainerView.heightAnchor.constraint(equalTo: heightAnchor),
            timerContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            pauseResumeButton.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor),
            pauseResumeButton.heightAnchor.constraint(equalTo: timerContainerView.heightAnchor),
            pauseResumeButton.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            pauseResumeButton.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor)
        ])
    }
    
    private func setupLayers() {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: frame.width / 2, startAngle: -(CGFloat.pi / 2), endAngle: -(CGFloat.pi / 2) + CGFloat.pi * 2, clockwise: true)
        
        let lineWidth = bounds.width * (4 / 44)
        
        timerTrackLayer.path = arcPath.cgPath
        timerTrackLayer.strokeColor = UIColor.systemGray5.cgColor
        timerTrackLayer.lineWidth = lineWidth
        timerTrackLayer.fillColor = UIColor.clear.cgColor
        timerTrackLayer.lineCap = .round
        timerTrackLayer.strokeEnd = 1
        
        timerCircleFillLayer.path = arcPath.cgPath
        timerCircleFillLayer.strokeColor = color?.cgColor
        timerCircleFillLayer.lineWidth = lineWidth
        timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        timerCircleFillLayer.lineCap = .round
        timerCircleFillLayer.strokeEnd = progress
        
        pauseResumeButton.layer.addSublayer(timerTrackLayer)
        pauseResumeButton.layer.addSublayer(timerCircleFillLayer)
        
        timerContainerView.layer.cornerRadius = timerContainerView.frame.width / 2
    }
}
