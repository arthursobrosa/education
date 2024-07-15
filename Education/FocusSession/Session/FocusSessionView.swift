//
//  FocusSessionView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionView: UIView {
    weak var delegate: FocusSessionDelegate?
    
    // MARK: - Properties
    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 50)
        lbl.textColor = .label
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timerTrackLayer = CAShapeLayer()
    private let timerCircleFillLayer = CAShapeLayer()
    
    private let timerEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
        return strokeEnd
    }()
    
    private let timerResetAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        return strokeEnd
    }()
    
    private lazy var pauseResumeButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.tintColor = .label
        bttn.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        bttn.addTarget(self, action: #selector(pauseResumeButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var finishButton: ButtonComponent = {
        let bttn = ButtonComponent(frame: .zero, title: "Finish")
        bttn.isEnabled = false
        bttn.alpha = 0.5
        
        bttn.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
        
        return bttn
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    @objc private func pauseResumeButtonTapped() {
        self.finishButton.isEnabled.toggle()
        self.changeButtonAlpha()
        self.delegate?.pauseResumeButtonTapped()
    }
    
    private func changeButtonAlpha() {
        let isEnabled = self.finishButton.isEnabled
        self.finishButton.alpha = isEnabled ? 1 : 0.5
    }
    
    @objc private func didTapFinishButton(_ sender: UIButton) {
        self.delegate?.saveFocusSession()
        self.delegate?.unblockApps()
    }
    
    func startAnimation(timerDuration: Double, timerString: String) {
        self.timerEndAnimation.duration = timerDuration
        
        self.updateLabels(timerString: timerString)
        
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    func resetAnimations() {
        self.timerCircleFillLayer.removeAllAnimations()
    }
    
    func changePauseResumeImage(to imageName: String) {
        UIView.transition(with: self.pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.pauseResumeButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        }
    }
    
    func hidePauseResumeButton() {
        self.pauseResumeButton.isEnabled = false
        self.timerCircleFillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    func redefineAnimation(timerDuration: Double, strokeEnd: CGFloat) {
        self.timerCircleFillLayer.strokeEnd = strokeEnd
        self.timerEndAnimation.duration = timerDuration
    }
}

// MARK: - UI Setup
extension FocusSessionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerContainerView)
        timerContainerView.addSubview(timerLabel)
        
        self.addSubview(pauseResumeButton)
        self.addSubview(finishButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            timerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            timerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.385),
            timerContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            timerContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            timerLabel.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor, multiplier: 1),
            timerLabel.heightAnchor.constraint(equalTo: timerLabel.widthAnchor),
            
            pauseResumeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: padding * 2),
            pauseResumeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            finishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            finishButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            finishButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            finishButton.heightAnchor.constraint(equalTo: finishButton.widthAnchor, multiplier: 0.16)
        ])
    }
    
    func setupLayers() {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: self.timerLabel.frame.width / 2, y: self.timerLabel.frame.height / 2), radius: self.timerLabel.frame.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        
        self.timerTrackLayer.path = arcPath.cgPath
        self.timerTrackLayer.strokeColor = UIColor.systemGray5.cgColor
        self.timerTrackLayer.lineWidth = 20
        self.timerTrackLayer.fillColor = UIColor.clear.cgColor
        self.timerTrackLayer.lineCap = .round
        self.timerTrackLayer.strokeEnd = 1
        
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = UIColor.label.cgColor
        self.timerCircleFillLayer.lineWidth = 20
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = 0
        
        self.timerLabel.layer.addSublayer(timerTrackLayer)
        self.timerLabel.layer.addSublayer(timerCircleFillLayer)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
    
    func updateLabels(timerString: String) {
        self.timerLabel.text = timerString
    }
}
