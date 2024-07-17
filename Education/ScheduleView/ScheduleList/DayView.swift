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
}

class DayView: UIView {
    // MARK: - Delegate
    weak var delegate: DayDelegate?
    
    // MARK: - Properties
    var dayOfWeek: DayOfWeek? {
        didSet {
            guard let dayOfWeek = dayOfWeek else { return }
            
            self.dayLabel.text = dayOfWeek.day
            self.dayLabel.textColor = dayOfWeek.isSelected ? .white : .label
            
            self.dateLabel.text = dayOfWeek.date
            self.dateLabel.textColor = dayOfWeek.isSelected ? .white : .label
            
            self.backgroundColor = dayOfWeek.isSelected ? .systemBlue : .clear
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
        self.addSubview(dateLabel)
        
        let padding = 4.0
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}
