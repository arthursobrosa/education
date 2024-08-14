//
//  ScheduleDetailsModalView.swift
//  Education
//
//  Created by Lucas Cunha on 13/08/24.
//

import UIKit

class ScheduleDetailsModalView: UIView {
    private var color: UIColor?
    
    private let closeButton: UIButton = {
        
        let btn = UIButton()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let img = UIImage(systemName: "xmark")
        
        imageAttachment.image = img?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 22, height: 22)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)

        btn.setAttributedTitle(attributedString, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let editButton: UIButton = {
        
        let btn = UIButton()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let img = UIImage(systemName: "square.and.pencil")
        
        imageAttachment.image = img?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 25, height: 25)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)

        btn.setAttributedTitle(attributedString, for: .normal)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let nameLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.text = "Biologia"
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let dayLabel: UILabel = {
        
        let lbl = UILabel()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        
        lbl.font = UIFont.systemFont(ofSize: 22)
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 22, height: 22)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: "Segunda-feira"))

        lbl.attributedText = attributedString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let HourDetailView: HourDetailsView = {
        
        let view = HourDetailsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        
        let btn = UIButton()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let img = UIImage(systemName: "play.fill")
        
        imageAttachment.image = img?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 19, height: 19)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(NSAttributedString(string: "Iniciar agora"))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(imageString)
        

        btn.setAttributedTitle(attributedString, for: .normal)
        
        
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .black.withAlphaComponent(0.6)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()

    init(color: UIColor?) {
        super.init(frame: .zero)
        
        self.color = color
        self.setupUI()
        
        self.backgroundColor = color
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScheduleDetailsModalView: ViewCodeProtocol {
    func setupUI() {
        addSubview(closeButton)
        addSubview(editButton)
        addSubview(nameLabel)
        addSubview(dayLabel)
        addSubview(HourDetailView)
        addSubview(startButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            
            nameLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            HourDetailView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: padding),
            HourDetailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding*1.5),
            HourDetailView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 102/385),
            HourDetailView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 321/385),
            
            startButton.topAnchor.constraint(equalTo: HourDetailView.bottomAnchor, constant: padding * 2),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 52/385),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 321/385),
        ])
    }
}

#Preview{
    ScheduleDetailsModalViewController(color: UIColor(named: "ScheduleColor1"))
}
