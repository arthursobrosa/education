//
//  FocusSessionView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionView: UIView, TimerAnimation {
    weak var delegate: FocusSessionDelegate? {
        didSet {
            setupUI()
        }
    }
    
    // MARK: - Properties
    private let color: UIColor?
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .label
        
        button.addTarget(delegate, action: #selector(FocusSessionDelegate.dismissButtonTapped), for: .touchUpInside)
        
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
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        
        button.addTarget(delegate, action: #selector(FocusSessionDelegate.eyeButtonTapped), for: .touchUpInside)
        
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
    
    var timerTrackLayer = CAShapeLayer()
    var timerCircleFillLayer = CAShapeLayer()
    
    var timerAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
        return strokeEnd
    }()
    
    private lazy var pauseResumeButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.tintColor = color
        bttn.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 48, weight: .regular, scale: .default)), for: .normal)
        bttn.addTarget(delegate, action: #selector(FocusSessionDelegate.pauseResumeButtonTapped), for: .touchUpInside)
        
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
        
        let bttn = ButtonComponent(title: String(), textColor: nil, cornerRadius: 28)
        bttn.setAttributedTitle(attributedString, for: .normal)
        bttn.backgroundColor = .clear
        
        bttn.layer.borderColor = UIColor.secondaryLabel.cgColor
        bttn.layer.borderWidth = 1
        
        bttn.alpha = 0
        
        bttn.addTarget(delegate, action: #selector(FocusSessionDelegate.didTapRestartButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var finishButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "focusFinish"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        bttn.backgroundColor = .clear
        
        bttn.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        
        bttn.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        bttn.layer.borderWidth = 1
        
        bttn.alpha = 0
        
        bttn.addTarget(delegate, action: #selector(FocusSessionDelegate.didTapFinishButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    let statusAlertView: FocusStatusAlertView = {
        let view = FocusStatusAlertView()
        
        view.isHidden = true
        view.layer.zPosition = 2
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let extensionAlertView: FocusExtensionAlertView = {
        let view = FocusExtensionAlertView()
        
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
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Visibility
extension FocusSessionView {
    // MARK: - Buttons visibility
    func changeButtonsVisibility(isHidden: Bool) {
        /// For a better understanding let's separate the buttons in two categories: "pause/resume button" and "other buttons"
        ///  where "other buttons" is composed of the dismiss, visibility, restart and finish buttons
        
        let duration: TimeInterval = 1
        let alpha: Double = isHidden ? 0 : 1
        let relativeDuration = Double(duration / 2)
        let pauseResumeStartTime: Double = isHidden ? 0.5 : 0
        let otherButtonsStartTime: Double = isHidden ? 0 : 0.5
        
        UIView.animateKeyframes(withDuration: duration, delay: 0) { [weak self] in
            guard let self else { return }
            
            UIView.addKeyframe(withRelativeStartTime: pauseResumeStartTime, relativeDuration: relativeDuration) {
                self.applyTranslation(to: self.pauseResumeButton, duration: relativeDuration, isHidden: isHidden)
            }
            
            UIView.addKeyframe(withRelativeStartTime: otherButtonsStartTime, relativeDuration: relativeDuration) {
                self.dismissButton.alpha = alpha
                self.eyeButton.alpha = alpha
                self.restartButton.alpha = alpha
                self.finishButton.alpha = alpha
            }
        }
    }
    
    private func applyTranslation(to view: UIView, duration: CFTimeInterval, isHidden: Bool) {
        let yOffset = isHidden ? 80.0 : -80.0
        
        let translationTransform = CATransform3DMakeTranslation(0, yOffset, 0)
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.duration = duration
        animation.fromValue = view.layer.transform
        animation.toValue = translationTransform
        view.layer.add(animation, forKey: "transform")
        
        view.layer.transform = CATransform3DConcat(view.layer.transform, translationTransform)
    }
    
    // MARK: - Eye button
    func setEyeButton(isActive: Bool) {
        let imageName = isActive ? "eye" : "eye.slash"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        eyeButton.tintColor = .label
        
        addSubview(eyeButton)
        
        NSLayoutConstraint.activate([
            eyeButton.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}

// MARK: - UI Updates
extension FocusSessionView {
    // MARK: - Title
    func setTitleLabel() {
        let attributedText = delegate?.getTitleString()
        activityTitle.attributedText = attributedText
    }
    
    func showPomodoroLabel() {
        pomodoroLabel.isHidden = false
    }
    
    // MARK: - Timer Labels
    func updateTimerLabels(timerString: String, pomodoroString: String) {
        timerLabel.text = timerString
        
        guard !pomodoroLabel.isHidden else { return }
        
        pomodoroLabel.text = pomodoroString
    }
    
    // MARK: - Pause/Resume Button
    func updatePauseResumeButton(isPaused: Bool) {
        let imageName = isPaused ? "play.fill" : "pause.fill"
        
        UIView.transition(with: pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            guard let self else { return }
            self.pauseResumeButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        }
    }
    
    func enablePauseResumeButton() {
        pauseResumeButton.isEnabled = true
    }
    
    func disablePauseResumeButton() {
        pauseResumeButton.isEnabled = false
        timerCircleFillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    // MARK: - Timer Tracker
    func updateTimerTracker(isShowing: Bool) {
        timerTrackLayer.strokeColor = isShowing ? UIColor.systemGray5.cgColor : UIColor.clear.cgColor
    }
}

// MARK: - Alerts
extension FocusSessionView {
    func changeAlertVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            
            self.statusAlertView.isHidden = !isShowing
            self.overlayView.alpha = isShowing ? 1 : 0
        }
    }
}

// MARK: - UI Setup
extension FocusSessionView: ViewCodeProtocol {
    func setupUI() {
        addSubview(dismissButton)
        addSubview(activityTitle)
        addSubview(pomodoroLabel)
        addSubview(timerContainerView)
        timerContainerView.addSubview(timerLabel)
        
        addSubview(pauseResumeButton)
        
        addSubview(restartButton)
        addSubview(finishButton)
        addSubview(statusAlertView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        
            activityTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            activityTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pomodoroLabel.topAnchor.constraint(equalTo: activityTitle.bottomAnchor, constant: 21),
            pomodoroLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            timerContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 300 / 844),
            timerContainerView.widthAnchor.constraint(equalTo: timerContainerView.heightAnchor, multiplier: 290 / 300),
            timerContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor),
            timerLabel.heightAnchor.constraint(equalTo: timerLabel.widthAnchor),
            
            pauseResumeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseResumeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 100),
            
            restartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            restartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            restartButton.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -8),
            restartButton.heightAnchor.constraint(equalTo: restartButton.widthAnchor, multiplier: 55 / 334),
            
            finishButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            finishButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -17),
            finishButton.widthAnchor.constraint(equalTo: restartButton.widthAnchor),
            finishButton.heightAnchor.constraint(equalTo: restartButton.heightAnchor),
        ])
        
        addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setupLayers(with configuration: ActivityManager.LayersConfig) {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width / 2, y: timerLabel.frame.height / 2), radius: timerLabel.frame.width / 2, startAngle: configuration.startAngle, endAngle: configuration.endAngle, clockwise: configuration.isClockwise)
        
        let lineWidth = bounds.height * (7 / 844)
        
        timerTrackLayer.path = arcPath.cgPath
        timerTrackLayer.strokeColor = configuration.isTimerTrackerShowing ? UIColor.systemGray5.cgColor : UIColor.clear.cgColor
        timerTrackLayer.lineWidth = lineWidth
        timerTrackLayer.fillColor = UIColor.clear.cgColor
        timerTrackLayer.lineCap = .round
        timerTrackLayer.strokeEnd = 1
        
        timerCircleFillLayer.path = arcPath.cgPath
        timerCircleFillLayer.strokeColor = color?.cgColor
        timerCircleFillLayer.lineWidth = lineWidth
        timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        timerCircleFillLayer.lineCap = .round
        timerCircleFillLayer.strokeEnd = configuration.strokeEnd
        
        timerLabel.layer.addSublayer(timerTrackLayer)
        timerLabel.layer.addSublayer(timerCircleFillLayer)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
}
