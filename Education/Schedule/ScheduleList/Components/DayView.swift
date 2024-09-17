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
    weak var delegate: ScheduleDelegate?
    
    // MARK: - Properties
    var dayOfWeek: DayOfWeek? {
        didSet {
            guard let dayOfWeek else { return }
            
            self.dayLabel.text = dayOfWeek.day.lowercased()
            self.dateLabel.text = dayOfWeek.date
            
            self.handleDayColors()
        }
    }
    
    // MARK: - UI Components
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 13)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.circleView.layer.cornerRadius = self.circleView.bounds.width / 2
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
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            circleView.widthAnchor.constraint(equalTo: self.widthAnchor),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
            
            dateLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
        ])
    }
    
    func handleDayColors() {
        guard let dayOfWeek else { return }
        
        let isSelected = dayOfWeek.isSelected
        let isToday = dayOfWeek.isToday
        
        let dayLabelFontName = (isSelected || isToday) ? Fonts.darkModeOnRegular : Fonts.darkModeOnMedium
        
        self.dayLabel.font = UIFont(name: dayLabelFontName, size: 13)
        self.dayLabel.textColor = (isSelected || isToday) ? .label : .secondaryLabel
        
        let dateLabelFontName = isSelected ? Fonts.darkModeOnSemiBold : Fonts.darkModeOnMedium
        
        self.dateLabel.font = UIFont(name: dateLabelFontName, size: 15)
        self.dateLabel.textColor = isSelected ? .systemBackground : (isToday ? .label : .secondaryLabel)
        
        self.circleView.layer.borderColor = isToday ? UIColor.label.cgColor : UIColor.secondaryLabel.cgColor
        self.circleView.layer.borderWidth = isSelected ? 0 : 1
        self.circleView.backgroundColor = isSelected ? .label : .clear
    }
}
