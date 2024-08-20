//
//  ActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityView: UIView {
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
    
    private let progressView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var progressWidthConstraint: NSLayoutConstraint!
    
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
    
    func updateTimer(timerSeconds: Int) {
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
    
    func updateProgressBar(progress: CGFloat) {
        self.progressWidthConstraint.constant = progress * self.bounds.width
        
        UIView.animate(withDuration: 1/60) {
            self.layoutIfNeeded()
        }
    }
}

extension ActivityView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(progressView)
        self.addSubview(activityTitle)
        self.addSubview(activityTimer)
        self.addSubview(activityButton)
        
        self.progressWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: 0)
        self.progressWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            progressView.heightAnchor.constraint(equalTo: self.heightAnchor),
            progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            activityTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            
            activityTimer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (76/390)),
            activityTimer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            activityButton.leadingAnchor.constraint(equalTo: activityTimer.trailingAnchor, constant: 8),
            activityButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (52/390)),
            activityButton.heightAnchor.constraint(equalTo: activityButton.widthAnchor),
            activityButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22)
        ])
    }
}
