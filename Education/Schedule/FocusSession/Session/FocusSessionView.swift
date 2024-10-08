//
//  FocusSessionView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import UIKit

class FocusSessionView: UIView {
    weak var delegate: FocusSessionDelegate? {
        didSet {
            setEndNotificationView()
            setupUI()
        }
    }
    
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
        
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
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
        
        let bttn = ButtonComponent(title: String(), textColor: nil, cornerRadius: 28)
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
        let bttn = ButtonComponent(title: String(localized: "focusFinish"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        bttn.backgroundColor = .clear
        
        bttn.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        
        bttn.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        bttn.layer.borderWidth = 1
        
        bttn.alpha = 0
        
        bttn.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private var endNotification: NotificationComponentView?
    
    lazy var overlayViewEnd: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        view.layer.zPosition = 2
        
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    @objc private func dismissButtonTapped() {
        self.delegate?.dismissButtonTapped()
    }
    
    @objc private func visibilityButtonTapped() {
        self.delegate?.visibilityButtonTapped()
    }
    
    @objc private func pauseResumeButtonTapped() {
        self.isPaused.toggle()
        self.delegate?.pauseResumeButtonTapped()
    }
    
    @objc private func didTapRestartButton() {
        self.focusAlert.configure(with: .restart)
        self.showFocusAlert(true)
    }
    
    @objc private func didTapFinishButton() {
        self.focusAlert.configure(with: .finish)
        self.showFocusAlert(true)
    }
}

// MARK: - Timer Animations
extension FocusSessionView {
    func startAnimation(timerDuration: Double) {
        self.timerEndAnimation.duration = timerDuration
        
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    func resetAnimations() {
        self.timerCircleFillLayer.removeAllAnimations()
    }
    
    func redefineAnimation(timerDuration: Double, strokeEnd: CGFloat) {
        self.timerCircleFillLayer.strokeEnd = strokeEnd
        self.timerEndAnimation.duration = timerDuration
    }
}

// MARK: - Visibility
extension FocusSessionView {
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
                self.visibilityButton.alpha = alpha
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
    
    func setVisibilityButton(isActive: Bool) {
        let imageName = isActive ? "eye" : "eye.slash"
        self.visibilityButton.setImage(UIImage(systemName: imageName), for: .normal)
        self.visibilityButton.tintColor = .label
        
        self.addSubview(visibilityButton)
        
        NSLayoutConstraint.activate([
            visibilityButton.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            visibilityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
}

// MARK: - UI Updates
extension FocusSessionView {
    // MARK: - Title
    func showPomodoroLabel() {
        self.pomodoroLabel.isHidden = false
    }
    
    // MARK: - Timer Labels
    func updateTimerLabels(timerString: String, pomodoroString: String) {
        self.timerLabel.text = timerString
        
        guard !self.pomodoroLabel.isHidden else { return }
        
        self.pomodoroLabel.text = pomodoroString
    }
    
    // MARK: - Pause/Resume Button
    func updatePauseResumeButton() {
        let imageName = isPaused ? "play.fill" : "pause.fill"
        
        UIView.transition(with: self.pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.pauseResumeButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .semibold, scale: .default)), for: .normal)
        }
    }
    
    func disablePauseResumeButton() {
        self.pauseResumeButton.isEnabled = false
        self.timerCircleFillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    // MARK: - Timer Tracker
    func updateTimerTracker(isShowing: Bool) {
        self.timerTrackLayer.strokeColor = isShowing ? UIColor.systemGray5.cgColor : UIColor.clear.cgColor
    }
}

// MARK: - Alerts
extension FocusSessionView {
    private func setEndNotificationView() {
        let endView = delegate?.createNotificationComponent()
        
        guard let endView else { return }
        
        endView.translatesAutoresizingMaskIntoConstraints = false
        
        endNotification = endView
    }
    
    func showEndNotification(_ isShowing: Bool) {
        self.overlayViewEnd.isHidden = !isShowing
    }
    
    func showFocusAlert(_ isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            
            self.focusAlert.isHidden = !isShowing
            self.overlayView.alpha = self.overlayView.alpha == 0 ? 1 : 0
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
        addSubview(focusAlert)
        
        addSubview(overlayViewEnd)
        
        guard let endNotification else { return }
        
        overlayViewEnd.addSubview(endNotification)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 4),
            dismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        
            activityTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
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
            
            pauseResumeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseResumeButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 100),
            
            restartButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            restartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            restartButton.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -8),
            restartButton.heightAnchor.constraint(equalTo: restartButton.widthAnchor, multiplier: 0.16),
            
            finishButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            finishButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            finishButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            finishButton.heightAnchor.constraint(equalTo: restartButton.heightAnchor),
            
            overlayViewEnd.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayViewEnd.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            overlayViewEnd.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayViewEnd.topAnchor.constraint(equalTo: self.topAnchor),
            
            endNotification.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            endNotification.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            endNotification.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 360/390),
            endNotification.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 228/844),
            
            focusAlert.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            focusAlert.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            focusAlert.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 366/390),
            focusAlert.heightAnchor.constraint(equalTo: focusAlert.widthAnchor, multiplier: 228/366)
        ])
        
        self.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupLayers(with configuration: FocusSessionViewModel.LayersConfig) {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width / 2, y: timerLabel.frame.height / 2), radius: timerLabel.frame.width / 2, startAngle: configuration.startAngle, endAngle: configuration.endAngle, clockwise: configuration.isClockwise)
        
        let lineWidth = bounds.height * (7/844)
        
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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
    
    func setTitleLabel(for subject: Subject?) {
        guard let subject else { return }
        
        let attributedString = NSMutableAttributedString()
        
        let activityString = NSAttributedString(string: "\(String(localized: "subjectActivity"))\n", attributes: [.font : UIFont(name: Fonts.darkModeOnMedium, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium), .foregroundColor : UIColor.label.withAlphaComponent(0.7)])
        let subjectString = NSAttributedString(string: subject.unwrappedName, attributes: [.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold), .foregroundColor : UIColor.label.withAlphaComponent(0.85)])
        
        attributedString.append(activityString)
        attributedString.append(subjectString)
        
        self.activityTitle.attributedText = attributedString
    }
}
