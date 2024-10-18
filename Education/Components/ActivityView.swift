//
//  ActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityView: UIView {
    // MARK: - Delegate to connect with tab bar
    weak var delegate: TabBarDelegate?
    
    // MARK: - Properties
    var subject: Subject? {
        didSet {
            if let subject {
                activityTitle.text = subject.unwrappedName
                return
            }
            
            activityTitle.text = String(localized: "newActivity")
        }
    }
    
    var timerSeconds: Int? {
        didSet {
            guard let timerSeconds else { return }
            
            updateTimer(timerSeconds: timerSeconds)
        }
    }
    
    var color: UIColor? {
        didSet {
            studyingNowLabel.textColor = color?.darker(by: 1.3)
            activityTitle.textColor = color?.darker(by: 0.6)
            activityTimer.textColor = color
        }
    }
    
    var progress: CGFloat? {
        didSet {
            guard let color,
                  let progress else { return }
            
            addLiveActivityButton(color: color, progress: progress)
        }
    }
    
    // MARK: - UI Properties
    private let studyingNowLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String(localized: "studyingNow")
        lbl.font = UIFont(name: Fonts.darkModeOnMedium, size: 13)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let activityTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 17)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let activityTimer: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 17)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    var liveActivityButton: LiveActivityButton?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.layer.shadowColor = UIColor.label.cgColor
        }
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height * (18 / 60)
    }
    
    // MARK: - Methods
    private func updateTimer(timerSeconds: Int) {
        let seconds = timerSeconds % 60
        let minutes = timerSeconds / 60 % 60
        let hours = timerSeconds / 3600
        
        let secondsText = getText(from: seconds)
        let minutesText = getText(from: minutes)
        let hoursText = getText(from: hours)
        
        let timerText = "\(hoursText):\(minutesText):\(secondsText)"
        
        activityTimer.text = timerText
    }
    
    private func getText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}

// MARK: - UI Setup
extension ActivityView: ViewCodeProtocol {
    func setupUI() {
        addSubview(studyingNowLabel)
        addSubview(activityTitle)
        addSubview(activityTimer)
        
        NSLayoutConstraint.activate([
            studyingNowLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            studyingNowLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            
            activityTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            activityTitle.leadingAnchor.constraint(equalTo: studyingNowLabel.leadingAnchor),
            
            activityTimer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80 / 366),
            activityTimer.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addLiveActivityButton(color: UIColor?, progress: CGFloat) {
        liveActivityButton = LiveActivityButton(color: color, progress: progress)
        liveActivityButton?.pauseResumeButton.addTarget(delegate, action: #selector(TabBarDelegate.didTapPlayButton), for: .touchUpInside)
        liveActivityButton?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let liveActivityButton else { return }
        
        addSubview(liveActivityButton)
        
        NSLayoutConstraint.activate([
            liveActivityButton.leadingAnchor.constraint(equalTo: activityTimer.trailingAnchor, constant: 13),
            liveActivityButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 44 / 366),
            liveActivityButton.heightAnchor.constraint(equalTo: liveActivityButton.widthAnchor),
            liveActivityButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            liveActivityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
