//
//  DayView.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

struct DayOfWeek {
    let day: String
    let date: String
    let isSelected: Bool
    let isToday: Bool
}

class DayView: UIView {
    // MARK: - Delegate
    weak var delegate: DayDelegate?
    
    // MARK: - Properties
    var dayOfWeek: DayOfWeek? {
        didSet {
            guard let dayOfWeek = dayOfWeek else { return }
            
            self.dayLabel.text = dayOfWeek.day.capitalized
            self.dateLabel.text = dayOfWeek.date
            
            handleDayColors()
            
        }
    }
    
    // MARK: - UI Components
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayViewTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func dayViewTapped() {
        self.delegate?.dayTapped(self)
    }
}

// MARK: UI Setup
extension DayView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(dayLabel)
        circleView.addSubview(dateLabel)
        self.addSubview(circleView)
        
        let padding = 4.0
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            circleView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: padding),
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            circleView.widthAnchor.constraint(equalToConstant: 36),
            circleView.heightAnchor.constraint(equalToConstant: 36),
            
            dateLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            
        ])
        
        
    }
    
    func handleDayColors(){
        guard let dayOfWeek else {return}
        if (dayOfWeek.isSelected) {
            self.dayLabel.textColor = .systemBlue
            self.dateLabel.textColor = .systemBackground
            self.circleView.layer.borderColor = UIColor.systemBlue.cgColor
            self.circleView.backgroundColor = .systemBlue
        } else if(dayOfWeek.isToday) {
            self.dayLabel.textColor = .systemBlue
            self.dateLabel.textColor = .systemBlue
            self.circleView.layer.borderColor = UIColor.systemBlue.cgColor
            self.circleView.layer.borderWidth = 1.0
            self.circleView.backgroundColor = .clear
        } else {
            self.dayLabel.textColor = .secondaryLabel
            self.dateLabel.textColor = .secondaryLabel
            self.circleView.layer.borderWidth = 1.0
            self.circleView.layer.borderColor = UIColor.secondaryLabel.cgColor
            self.circleView.backgroundColor = .clear
        }
    }
}
