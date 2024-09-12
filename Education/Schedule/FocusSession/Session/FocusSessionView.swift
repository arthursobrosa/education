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
        
        button.isHidden = true
        
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
    
    private lazy var visibilityButton: UIButton = {
        let button = UIButton(configuration: .plain())
        
        button.addTarget(self, action: #selector(visibilityButtonTapped), for: .touchUpInside)
        
        button.isHidden = true
        
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
        lbl.font = .systemFont(ofSize: 44, weight: .light)
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
        attributedString.addAttributes([.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 18) ?? UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.label.withAlphaComponent(0.55)], range: .init(location: 0, length: attributedString.length))
        
        let bttn = ButtonComponent(title: String(), textColor: nil)
        bttn.setAttributedTitle(attributedString, for: .normal)
        bttn.backgroundColor = .systemGray6
        
        bttn.isHidden = true
        
        bttn.addTarget(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var finishButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "focusFinish"), textColor: UIColor(named: "FocusSettingsColor"))
        bttn.backgroundColor = .systemGray6
        
        bttn.isHidden = true
        
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
    
    private lazy var finishEarlyNotification: UIView = {
        let view = NotificationWithCancelView(body: String(localized: "confirmActivityEnd"))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .init(width: 0, height: 0)
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            view.layer.shadowColor = UIColor.label.cgColor
        }
        
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
        self.dismissButton.isHidden = isHidden
        self.visibilityButton.isHidden = isHidden
        self.restartButton.isHidden = isHidden
        self.finishButton.isHidden = isHidden
    }
    
    func showEndNotification(_ isHidden: Bool) {
        self.endNotification.isHidden = isHidden
    }
    
    func showFinishNotification(_ isHidden: Bool) {
        self.finishEarlyNotification.isHidden = isHidden
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
        self.delegate?.didTapRestartButton()
        
        self.isPaused = false
    }
    
    @objc private func didTapFinishButton() {
        self.showFinishNotification(false)
    }
    
    func startAnimation(timerDuration: Double) {
        self.timerEndAnimation.duration = timerDuration
        
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    func resetAnimations() {
        self.timerCircleFillLayer.removeAllAnimations()
    }
    
    func hidePauseResumeButton() {
        self.pauseResumeButton.isEnabled = false
        self.timerCircleFillLayer.strokeColor = UIColor.clear.cgColor
    }
    
    func redefineAnimation(timerDuration: Double, strokeEnd: CGFloat) {
        self.timerCircleFillLayer.strokeEnd = strokeEnd
        self.timerEndAnimation.duration = timerDuration
    }
    
    func updateLabels(timerString: String) {
        self.timerLabel.text = timerString
    }
    
    func updateTimerTracker() {
        self.timerTrackLayer.strokeColor = UIColor.systemGray5.cgColor
    }
}

// MARK: - UI Setup
extension FocusSessionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(dismissButton)
        self.addSubview(activityTitle)
        self.addSubview(timerContainerView)
        timerContainerView.addSubview(timerLabel)
        
        let pauseResumeButtonContainer = UIView()
        pauseResumeButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pauseResumeButtonContainer)
        pauseResumeButtonContainer.addSubview(pauseResumeButton)
        
        self.addSubview(restartButton)
        self.addSubview(finishButton)
        self.addSubview(endNotification)
        self.addSubview(finishEarlyNotification)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: -6),
            dismissButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            activityTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            activityTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            timerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 300/844),
            timerContainerView.widthAnchor.constraint(equalTo: timerContainerView.heightAnchor, multiplier: 290/300),
            timerContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            timerLabel.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor),
            timerLabel.heightAnchor.constraint(equalTo: timerLabel.widthAnchor),
            
            pauseResumeButtonContainer.topAnchor.constraint(equalTo: timerLabel.bottomAnchor),
            pauseResumeButtonContainer.bottomAnchor.constraint(equalTo: restartButton.topAnchor),
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
            
            finishEarlyNotification.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            finishEarlyNotification.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            finishEarlyNotification.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            finishEarlyNotification.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 360/390),
            finishEarlyNotification.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 209/844)
        ])
    }
    
    func setupLayers(strokeEnd: CGFloat) {
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: self.timerLabel.frame.width / 2, y: self.timerLabel.frame.height / 2), radius: self.timerLabel.frame.width / 2, startAngle: -(CGFloat.pi / 2), endAngle: -(CGFloat.pi / 2) + CGFloat.pi * 2, clockwise: true)
        
        let lineWidth = self.bounds.height * (7/844)
        
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
        self.timerCircleFillLayer.strokeEnd = strokeEnd
        
        self.timerLabel.layer.addSublayer(timerTrackLayer)
        self.timerLabel.layer.addSublayer(timerCircleFillLayer)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
}
