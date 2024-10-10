//
//  NoSchedulesView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/09/24.
//

import UIKit

class NoSchedulesView: UIView {
    // MARK: - Properties
    enum NoSchedulesCase {
        case day
        case week
        
        var message: String {
            switch self {
                case .day:
                    String(localized: "emptyDaySchedule")
                case .week:
                    String(localized: "emptyWeekSchedule")
            }
        }
    }
    
    var noSchedulesCase: NoSchedulesCase? {
        didSet {
            guard let noSchedulesCase else { return }
            
            self.messageLabel.text = "🍃\n\n\(noSchedulesCase.message)"
            
            self.setupUI()
        }
    }
    
    // MARK: - UI Components
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .label.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}

// MARK: - UI Setup
extension NoSchedulesView: ViewCodeProtocol {
    func setupUI() {
        guard let noSchedulesCase else { return }
        
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        addSubview(messageLabel)
        
        var topPadding = Double()
        
        switch noSchedulesCase {
            case .day:
                topPadding = 150
            case .week:
                topPadding = 226
        }
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 245 / 390),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: topPadding)
        ])
    }
}
