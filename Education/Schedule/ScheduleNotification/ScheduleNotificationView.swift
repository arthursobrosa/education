//
//  ScheduleNotificationView.swift
//  Education
//
//  Created by Lucas Cunha on 14/08/24.
//

import UIKit

class ScheduleNotificationView: UIView {
    weak var delegate: ScheduleNotificationDelegate?
    
    private let startTime: String
    private let endTime: String
    private let subjectName: String
    private var color: UIColor?
    
    private let clockLabel: UILabel = {
        
        let lbl = UILabel()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        
        lbl.font = UIFont.systemFont(ofSize: 22)
        imageAttachment.image = UIImage(systemName: "clock.badge.checkmark")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 52, height: 47)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)

        lbl.attributedText = attributedString
        lbl.alpha = 0.6
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()

    private let warningLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.text = "Está na hora da sua atividade"
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var scheduleNotificationCardView: ScheduleNotificationNameCard = {
        
        let view = ScheduleNotificationNameCard(starTime: self.startTime, endTime: self.endTime, subjectName: self.subjectName)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let btn = ActionButton(title: "Iniciar agora", titleColor: color?.darker(by: 0.5))
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var delayButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Adiar", for: .normal)
        btn.setTitleColor(color?.darker(by: 0.5), for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(didTapDelayButton), for: .touchUpInside)
        
        return btn
    }()

    init(startTime: String, endTime: String, color: UIColor?, subjectName: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
        self.subjectName = subjectName
        
        super.init(frame: .zero)
        
        self.setupUI()
        
        self.backgroundColor = color
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapStartButton(){
        self.delegate?.startButtonTapped()
    }
    
    @objc private func didTapDelayButton(){
        self.delegate?.dismiss()
    }
}

extension ScheduleNotificationView: ViewCodeProtocol {
    func setupUI() {
        addSubview(clockLabel)
        addSubview(warningLabel)
        addSubview(scheduleNotificationCardView)
        addSubview(startButton)
        addSubview(delayButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            clockLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding * 3),
            clockLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            warningLabel.topAnchor.constraint(equalTo: clockLabel.bottomAnchor, constant: padding),
            warningLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            scheduleNotificationCardView.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: padding),
            scheduleNotificationCardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            scheduleNotificationCardView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 219/588),
            scheduleNotificationCardView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 342/359),
            
            startButton.topAnchor.constraint(equalTo: scheduleNotificationCardView.bottomAnchor, constant: padding * 3),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 40/385),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 320/385),
            
            delayButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: padding * 0.5),
            delayButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
}
