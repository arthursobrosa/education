//
//  ActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityView: UIView {
    var timerSeconds: Int = 0 {
        didSet {
            self.setTimerText()
        }
    }
    
    var isPaused: Bool = false {
        didSet {
            self.activityButton.isPaused = isPaused
        }
    }
    
    var subject: Subject? {
        didSet {
            if let subject = subject {
                self.activityTitle.text = subject.unwrappedName
                return
            }
            
            self.activityTitle.text = "New activity"
        }
    }
    
    var color: UIColor? {
        didSet {
            self.backgroundColor = color
            self.activityButton.activityState = .current(color: color?.getDarkerColor())
        }
    }
    
    var isAtWorkTime: Bool = false {
        didSet {
            guard !isAtWorkTime else { return }
            
            self.activityTitle.text = (self.activityTitle.text ?? String()) + " interval"
        }
    }
    
    private let activityTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textColor = .label
        lbl.textAlignment = .left
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let activityTimer: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = .label
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
}

extension ActivityView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(activityTitle)
        self.addSubview(activityTimer)
        self.addSubview(activityButton)
        
        NSLayoutConstraint.activate([
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
