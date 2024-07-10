//
//  FocusSessionView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionView: UIView {
    // MARK: - Properties
    let viewModel: FocusSessionViewModel
    
    var onTimerFinished: (() -> Void)?
    var onChangeTimerState: ((Bool) -> Void)?
    
    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        
        lbl.text = self.viewModel.getTimerString()
        
        lbl.font = .systemFont(ofSize: 50)
        lbl.textColor = .label
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timerTrackLayer = CAShapeLayer()
    private let timerCircleFillLayer = CAShapeLayer()
    
    private lazy var timerEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
        return strokeEnd
    }()
    
    private lazy var timerResetAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        return strokeEnd
    }()
    
    private lazy var pauseResumeButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.translatesAutoresizingMaskIntoConstraints = false
        bttn.tintColor = .label
        bttn.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        bttn.addTarget(self.viewModel, action: #selector(self.viewModel.pauseResumeButtonTapped), for: .touchUpInside)
        return bttn
    }()
    
    // MARK: - Initializer
    init(frame: CGRect = .zero, viewModel: FocusSessionViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.setupUI()
        
        self.viewModel.timerSeconds.bind { [weak self] timerSeconds in
            guard let self = self else { return }
            
            self.updateLabels()
            
            if timerSeconds == 0 {
                self.hidePauseResumeButton()
                
                self.resetTimer()
                
                self.onTimerFinished?()
            }
        }
        
        self.viewModel.timerState.bind { [weak self] timerState in
            guard let self = self else { return }
            
            guard let timerState = timerState else { return }
            
            switch timerState {
                case .starting:
                    self.startTimer()
                    self.onChangeTimerState?(false)
                case .reseting:
                    self.resetTimer()
                    self.redefineAnimation()
                    self.onChangeTimerState?(true)
            }
            
            self.changePauseResumeImage(to: timerState.imageName)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    private func startTimer() {
        self.timerEndAnimation.duration = Double(self.viewModel.timerSeconds.value)
        
        self.updateLabels()
        
        self.viewModel.startCountownTimer()
        
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    private func resetTimer() {
        self.viewModel.countdownTimer.invalidate()
        self.timerCircleFillLayer.removeAllAnimations()
    }
    
    private func changePauseResumeImage(to imageName: String) {
        UIView.transition(with: self.pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.pauseResumeButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        }
    }
    
    private func hidePauseResumeButton() {
        self.pauseResumeButton.isEnabled = false
        self.timerCircleFillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    private func redefineAnimation() {
        self.timerCircleFillLayer.strokeEnd = 1 - (CGFloat(self.viewModel.timerSeconds.value) / CGFloat(self.viewModel.totalSeconds))
        self.timerEndAnimation.duration = Double(self.viewModel.timerSeconds.value) + 1
    }
}

// MARK: - UI Setup
extension FocusSessionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerContainerView)
        timerContainerView.addSubview(timerLabel)
        
        self.addSubview(pauseResumeButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            timerContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.385),
            timerContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            timerContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            timerLabel.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor, multiplier: 1),
            timerLabel.heightAnchor.constraint(equalTo: timerLabel.widthAnchor),
            
            pauseResumeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: padding * 4),
            pauseResumeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupLayers() {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: self.timerLabel.frame.width / 2, y: self.timerLabel.frame.height / 2), radius: self.timerLabel.frame.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = UIColor.label.cgColor
        self.timerCircleFillLayer.lineWidth = 20
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = 0
        
        self.timerLabel.layer.addSublayer(timerCircleFillLayer)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
    
    private func updateLabels() {
        let seconds = self.viewModel.timerSeconds.value % 60
        let minutes = self.viewModel.timerSeconds.value / 60 % 60
        let hours = self.viewModel.timerSeconds.value / 3600
        
        let timeString = "\(hours)h \(minutes)m \(seconds)s"
        self.timerLabel.text = timeString
    }
}
