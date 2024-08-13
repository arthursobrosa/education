//
//  ActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityView: UIView {
    var totalSeconds: Int = 0 // This will be used to create the progress view
    
    var timerSeconds: Int = 0 {
        didSet {
            self.setTimerText()
//            self.updateProgress()
        }
    }
    
    private var percentage: Double = 0
    
    var isPaused: Bool = false {
        didSet {
            self.activityButton.isPaused = isPaused
        }
    }
    
    var subject: Subject? {
        didSet {
            if let subject {
                self.activityTitle.text = subject.unwrappedName
                return
            }
            
            self.activityTitle.text = String(localized: "newActivity")
        }
    }
    
    var color: UIColor? {
        didSet {
            self.backgroundColor = color
            self.progressView.backgroundColor = color?.darker(by: 0.6)
            self.activityButton.activityState = .current(color: color?.darker(by: 0.6))
        }
    }
    
    var isAtWorkTime: Bool = false {
        didSet {
            if let subject {
                self.activityTitle.text = isAtWorkTime ? subject.unwrappedName : subject.unwrappedName + " " + String(localized: "interval")
                
                return
            }
            
            self.activityTitle.text = isAtWorkTime ? String(localized: "newActivity") : String(localized: "newActivity") + " " + String(localized: "interval")
        }
    }
    
    private let progressView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let activityTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textColor = .white
        lbl.textAlignment = .left
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let activityTimer: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .white
        lbl.textAlignment = .left
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    let activityButton: ActivityButton = {
        let bttn = ActivityButton()
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = self.bounds.height / 6
        self.roundCorners(corners: [.topLeft, .topRight], radius: radius, borderWidth: 2, borderColor: .label)
        self.progressView.roundCorners(corners: [.topLeft], radius: radius, borderWidth: 0, borderColor: .clear)
    }
    
    private func setTimerText() {
        let seconds = self.timerSeconds % 60
        let minutes = self.timerSeconds / 60 % 60
        let hours = self.timerSeconds / 3600
        
        let secondsText = self.getText(from: seconds)
        let minutesText = self.getText(from: minutes)
        let hoursText = self.getText(from: hours)
        
        let text = "\(hoursText):\(minutesText):\(secondsText)"
        
        self.activityTimer.text = text
    }
    
    private func getText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    private func updateProgress() {
        guard self.totalSeconds > 0 else { return }
        
        let percentage = 1 - (Double(self.timerSeconds) / Double(totalSeconds))
        
        self.progressView.removeConstraints(self.progressView.constraints)
        
        NSLayoutConstraint.activate([
            self.progressView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: percentage)
        ])
        
        UIView.animate(withDuration: 1) {
            self.layoutIfNeeded()
        }
    }
}

extension ActivityView: ViewCodeProtocol {
    func setupUI() {
//        self.addSubview(progressView)
        self.addSubview(activityTitle)
        self.addSubview(activityTimer)
        self.addSubview(activityButton)
        
        NSLayoutConstraint.activate([
//            progressView.widthAnchor.constraint(equalToConstant: 0),
//            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            progressView.heightAnchor.constraint(equalTo: self.heightAnchor),
//            progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            activityTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            
            activityTimer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            activityButton.leadingAnchor.constraint(equalTo: activityTimer.trailingAnchor, constant: 8),
            activityButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (52/390)),
            activityButton.heightAnchor.constraint(equalTo: activityButton.widthAnchor),
            activityButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22)
        ])
    }
}
