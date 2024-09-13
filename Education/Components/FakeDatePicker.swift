//
//  FakeDatePicker.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/09/24.
//

import UIKit

class FakeDatePicker: UIDatePicker {
    override var date: Date {
        didSet {
            self.dateLabel.text = self.getDateString(from: date)
        }
    }
    
    private let dateContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .secondaryLabel
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(datePickerDidChange), for: .valueChanged)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func datePickerDidChange() {
        self.dateLabel.text = self.getDateString(from: self.date)
    }
    
    private func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        if self.datePickerMode == .date {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")
        } else {
            let is24HourFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.contains("a") == false

            if is24HourFormat {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "hh:mm a"
            }
        }
        
        return dateFormatter.string(from: date)
    }
}

private extension FakeDatePicker {
    func setupUI() {
        self.addSubview(dateContainerView)
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateContainerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            dateContainerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor)
        ])
    }
}
