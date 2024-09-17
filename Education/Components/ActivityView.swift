//
//  ActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityView: UIView {
    weak var delegate: TabBarDelegate?
    
    var subject: Subject? {
        didSet {
            if let subject {
                self.activityTitle.text = subject.unwrappedName
                return
            }
            
            self.activityTitle.text = String(localized: "newActivity")
        }
    }
    
    var timerSeconds: Int? {
        didSet {
            guard let timerSeconds else { return }
            
            self.updateTimer(timerSeconds: timerSeconds)
        }
    }
    
    var color: UIColor? {
        didSet {
            self.studyingNowLabel.textColor = color?.darker(by: 1.3)
            self.activityTitle.textColor = color?.darker(by: 0.6)
            self.activityTimer.textColor = color
        }
    }
    
    var progress: CGFloat? {
        didSet {
            guard let color,
                  let progress else { return }
            
            self.addLiveActivityButton(color: color, progress: progress)
        }
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.layer.shadowColor = UIColor.label.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 20
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.layer.shadowColor = UIColor.label.cgColor
        }
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height * (18/60)
    }
    
    private func updateTimer(timerSeconds: Int) {
        let seconds = timerSeconds % 60
        let minutes = timerSeconds / 60 % 60
        let hours = timerSeconds / 3600
        
        let secondsText = self.getText(from: seconds)
        let minutesText = self.getText(from: minutes)
        let hoursText = self.getText(from: hours)
        
        let timerText = "\(hoursText):\(minutesText):\(secondsText)"
        
        self.activityTimer.text = timerText
    }
    
    private func getText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    @objc private func didTapPlayButton() {
        self.delegate?.didTapPlayButton()
    }
}

extension ActivityView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(studyingNowLabel)
        self.addSubview(activityTitle)
        self.addSubview(activityTimer)
        
        NSLayoutConstraint.activate([
            studyingNowLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            studyingNowLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            
            activityTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11),
            activityTitle.leadingAnchor.constraint(equalTo: studyingNowLabel.leadingAnchor),
            
            activityTimer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (80/366)),
            activityTimer.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func addLiveActivityButton(color: UIColor?, progress: CGFloat) {
        let liveActivityButton = LiveActivityButton(color: color, progress: progress)
        liveActivityButton.playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        liveActivityButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(liveActivityButton)
        
        NSLayoutConstraint.activate([
            liveActivityButton.leadingAnchor.constraint(equalTo: activityTimer.trailingAnchor, constant: 13),
            liveActivityButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (44/366)),
            liveActivityButton.heightAnchor.constraint(equalTo: liveActivityButton.widthAnchor),
            liveActivityButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            liveActivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        ])
    }
}
