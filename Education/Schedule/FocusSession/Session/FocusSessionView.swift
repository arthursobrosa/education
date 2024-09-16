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
    private let color: UIColor?
    
    var isPaused: Bool = false {
        didSet {
            self.updatePauseResumeButton()
        }
    }
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .label
        
        button.addTarget(self, action: #selector(dismisButtonTapped), for: .touchUpInside)
        
        button.alpha = 0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let activityTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pomodoroLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        lbl.textColor = .label.withAlphaComponent(0.4)
        
        lbl.isHidden = true
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var visibilityButton: UIButton = {
        let button = UIButton(configuration: .plain())
        
        button.addTarget(self, action: #selector(visibilityButtonTapped), for: .touchUpInside)
        
        button.alpha = 0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont(name: Fonts.darkModeOnRegular, size: 37)
        lbl.textColor = .label.withAlphaComponent(0.8)
        
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
    
    private let pauseResumeButtonContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var pauseResumeBottomConstraint: NSLayoutConstraint!
    
    private lazy var pauseResumeButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.tintColor = self.color
        bttn.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 48, weight: .regular, scale: .default)), for: .normal)
        bttn.addTarget(self, action: #selector(pauseResumeButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var restartButton: ButtonComponent = {
        let attributedString = NSMutableAttributedString()
        let restartString = NSAttributedString(string: String(localized: "focusRestart"))
        let restartAttachment = NSTextAttachment(image: UIImage(systemName: "arrow.counterclockwise")!)
        let restartImage = NSAttributedString(attachment: restartAttachment)
        attributedString.append(restartString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(restartImage)
        attributedString.addAttributes([.font : UIFont(name: Fonts.darkModeOnMedium, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor : UIColor.label.withAlphaComponent(0.8)], range: .init(location: 0, length: attributedString.length))
        
        let bttn = ButtonComponent(title: String(), textColor: nil, cornerRadius: 30)
        bttn.setAttributedTitle(attributedString, for: .normal)
        bttn.backgroundColor = .clear
        
        bttn.layer.borderColor = UIColor.secondaryLabel.cgColor
        bttn.layer.borderWidth = 1
        
        bttn.alpha = 0
        
        bttn.addTarget(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var finishButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "focusFinish"), textColor: UIColor(named: "FocusSettingsColor"))
        bttn.backgroundColor = .clear
        
        bttn.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        
        bttn.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        bttn.layer.borderWidth = 1
        
        bttn.alpha = 0
        
        bttn.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var endNotification: UIView = {
        let view = NotificationComponentView(title: String(localized: "timeIsUp"),
                                    body: ((ActivityManager.shared.subject) != nil) ? String(localized: "activityEndCongratulations") + (ActivityManager.shared.subject!.unwrappedName)  + " 🎉" :
                                                String(localized: "noActivityEndCongratulations"),
                                    color: color ?? UIColor.systemGray5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private let focusAlert: FocusAlertView = {
        let view = FocusAlertView()
        
        view.isHidden = true
        view.layer.zPosition = 2
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.1)
        view.alpha = 0
        view.layer.zPosition = 1
        
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Initializer
    init(color: UIColor?) {
        self.color = color
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    func setTitleLabel(for subject: Subject?) {
        guard let subject else { return }
        
        let attributedString = NSMutableAttributedString()
        
        let activityString = NSAttributedString(string: "\(String(localized: "subjectActivity"))\n", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor : UIColor.label.withAlphaComponent(0.7)])
        let subjectString = NSAttributedString(string: subject.unwrappedName, attributes: [.font : UIFont.boldSystemFont(ofSize: 32), .foregroundColor : UIColor.label.withAlphaComponent(0.85)])
        
        attributedString.append(activityString)
        attributedString.append(subjectString)
        
        self.activityTitle.attributedText = attributedString
    }
    
    func changeButtonsIsHidden(_ isHidden: Bool) {
        let duration: TimeInterval = 1
        
        UIView.animateKeyframes(withDuration: 1, delay: 0) { [weak self] in
            guard let self else { return }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.pauseResumeButton.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                self.dismissButton.alpha = isHidden ? 0 : 1
                self.visibilityButton.alpha = isHidden ? 0 : 1
                self.restartButton.alpha = isHidden ? 0 : 1
                self.finishButton.alpha = isHidden ? 0 : 1
            }

            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.pauseResumeButton.alpha = 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.3) { [weak self] in
            guard let self else { return }
            
            self.removeConstraint(self.pauseResumeBottomConstraint)
            self.pauseResumeBottomConstraint = isHidden ? self.pauseResumeButtonContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor) : self.pauseResumeButtonContainer.bottomAnchor.constraint(equalTo: self.restartButton.topAnchor)
            self.pauseResumeBottomConstraint.isActive = true
        }
    }
    
    func showEndNotification(_ isShowing: Bool) {
        self.endNotification.isHidden = !isShowing
    }
    
    func showFocusAlert(_ isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            
            self.focusAlert.isHidden = !isShowing
            self.overlayView.alpha = self.overlayView.alpha == 0 ? 1 : 0
        }
    }
    
    func setVisibilityButton(isActive: Bool) {
        let imageName = isActive ? "eye" : "eye.slash"
        self.visibilityButton.setImage(UIImage(systemName: imageName), for: .normal)
        self.visibilityButton.tintColor = .label
        
        self.addSubview(visibilityButton)
        
        NSLayoutConstraint.activate([
            visibilityButton.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            visibilityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    @objc private func dismisButtonTapped() {
        self.delegate?.dismissButtonTapped()
    }
    
    @objc private func visibilityButtonTapped() {
        self.delegate?.visibilityButtonTapped()
    }
    
    @objc private func pauseResumeButtonTapped() {
        self.isPaused.toggle()
        self.delegate?.pauseResumeButtonTapped()
    }
    
    func updatePauseResumeButton() {
        let imageName = isPaused ? "play.fill" : "pause.fill"
        
        UIView.transition(with: self.pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.pauseResumeButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        }
    }
    
    @objc private func didTapRestartButton() {
        self.focusAlert.configure(with: .restart)
        self.showFocusAlert(true)
    }
    
    @objc private func didTapFinishButton() {
        self.focusAlert.configure(with: .finish)
        self.showFocusAlert(true)
    }
    
    func startAnimation(timerDuration: Double) {
        self.timerEndAnimation.duration = timerDuration
        
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    func resetAnimations() {
        self.timerCircleFillLayer.removeAllAnimations()
    }
    
    func disablePauseResumeButton() {
        self.pauseResumeButton.isEnabled = false
        self.timerCircleFillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    func redefineAnimation(timerDuration: Double, strokeEnd: CGFloat) {
        self.timerCircleFillLayer.strokeEnd = strokeEnd
        self.timerEndAnimation.duration = timerDuration
    }
    
    func updateLabels(timerString: String) {
        self.timerLabel.text = timerString
        
        guard !self.pomodoroLabel.isHidden else { return }
        
        let number = ActivityManager.shared.currentLoop + 1
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        guard let ordinalNumber = formatter.string(from: NSNumber(value: number)) else { return }
        
        let suffix = ActivityManager.shared.isAtWorkTime ? String(localized: "focusTime") : String(localized: "pauseTime")
        
        self.pomodoroLabel.text = ordinalNumber + " " + suffix
    }
    
    func updateTimerTracker() {
        var isShowing = true
        
        switch ActivityManager.shared.timerCase {
            case .stopwatch:
                isShowing = false
            default:
                break
        }
        
        self.timerTrackLayer.strokeColor = isShowing ? UIColor.systemGray5.cgColor : UIColor.clear.cgColor
    }
    
    func showPomodoroLabel() {
        self.pomodoroLabel.isHidden = false
    }
}

// MARK: - UI Setup
extension FocusSessionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(dismissButton)
        self.addSubview(activityTitle)
        self.addSubview(pomodoroLabel)
        self.addSubview(timerContainerView)
        timerContainerView.addSubview(timerLabel)
        
        self.addSubview(pauseResumeButtonContainer)
        pauseResumeButtonContainer.addSubview(pauseResumeButton)
        
        self.addSubview(restartButton)
        self.addSubview(finishButton)
        self.addSubview(endNotification)
        self.addSubview(focusAlert)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -6),
            dismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            activityTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            activityTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pomodoroLabel.topAnchor.constraint(equalTo: activityTitle.bottomAnchor, constant: 21),
            pomodoroLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            timerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 300/844),
            timerContainerView.widthAnchor.constraint(equalTo: timerContainerView.heightAnchor, multiplier: 290/300),
            timerContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor),
            timerLabel.heightAnchor.constraint(equalTo: timerLabel.widthAnchor),
            
            pauseResumeButtonContainer.topAnchor.constraint(equalTo: timerLabel.bottomAnchor),
            pauseResumeButtonContainer.widthAnchor.constraint(equalTo: self.widthAnchor),
            pauseResumeButtonContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pauseResumeButton.centerXAnchor.constraint(equalTo: pauseResumeButtonContainer.centerXAnchor),
            pauseResumeButton.centerYAnchor.constraint(equalTo: pauseResumeButtonContainer.centerYAnchor),
            
            restartButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            restartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            restartButton.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -8),
            restartButton.heightAnchor.constraint(equalTo: restartButton.widthAnchor, multiplier: 0.16),
            
            finishButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            finishButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            finishButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            finishButton.heightAnchor.constraint(equalTo: restartButton.heightAnchor),
            
            endNotification.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            endNotification.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            endNotification.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 360/390),
            endNotification.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 242/844),
            
            focusAlert.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            focusAlert.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            focusAlert.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 366/390),
            focusAlert.heightAnchor.constraint(equalTo: focusAlert.widthAnchor, multiplier: 228/366)
        ])
        
        self.pauseResumeBottomConstraint = pauseResumeButtonContainer.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        self.pauseResumeBottomConstraint.isActive = true
        
        
        self.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupLayers(strokeEnd: CGFloat) {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: self.timerLabel.frame.width / 2, y: self.timerLabel.frame.height / 2), radius: self.timerLabel.frame.width / 2, startAngle: -(CGFloat.pi / 2), endAngle: -(CGFloat.pi / 2) + CGFloat.pi * 2, clockwise: true)
        
        let lineWidth = self.bounds.height * (7/844)
        
        var isShowing = true
        
        switch ActivityManager.shared.timerCase {
            case .stopwatch:
                isShowing = false
            default:
                break
        }
        
        self.timerTrackLayer.path = arcPath.cgPath
        self.timerTrackLayer.strokeColor = isShowing ? UIColor.systemGray5.cgColor : UIColor.clear.cgColor
        self.timerTrackLayer.lineWidth = lineWidth
        self.timerTrackLayer.fillColor = UIColor.clear.cgColor
        self.timerTrackLayer.lineCap = .round
        self.timerTrackLayer.strokeEnd = 1
        
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = self.color?.cgColor
        self.timerCircleFillLayer.lineWidth = lineWidth
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = strokeEnd
        
        self.timerLabel.layer.addSublayer(timerTrackLayer)
        self.timerLabel.layer.addSublayer(timerCircleFillLayer)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
}
