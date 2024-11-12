//
//  NoSchedulesView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/09/24.
//

import UIKit

class NoSchedulesView: UIView {
    // MARK: - Delegate to connect with VC
    
    weak var delegate: ScheduleDelegate?
    
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

    var period: NoSchedulesCase? {
        didSet {
            guard let period else { return }

            messageLabel.text = period.message

            setupUI()
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
    
    private lazy var createActivityButton: ButtonComponent = {
        let createActivityString = String(localized: "createActivity")
        let font: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
        let color = UIColor.systemText80
        let createActivityAttrString = NSAttributedString(string: createActivityString,
                                                          attributes: [.font: font, .foregroundColor: color])
        
        let plusImage: UIImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17)).withTintColor(color) ?? UIImage()
        let plusImageAttachment = NSTextAttachment(image: plusImage)
        let plustImageAttrString = NSAttributedString(attachment: plusImageAttachment)
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(createActivityAttrString)
        mutableAttrString.append(NSAttributedString(string: String(repeating: " ", count: 2)))
        mutableAttrString.append(plustImageAttrString)
        
        let button = ButtonComponent(title: "", cornerRadius: 26)
        button.setAttributedTitle(mutableAttrString, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.buttonNormal.cgColor
        button.layer.borderWidth = 1
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            button.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        button.addTarget(delegate, action: #selector(ScheduleDelegate.createActivityButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension NoSchedulesView: ViewCodeProtocol {
    func setupUI() {
        addSubview(messageLabel)
        addSubview(createActivityButton)

        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 245 / 390),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            
            createActivityButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 28),
            createActivityButton.widthAnchor.constraint(equalTo: messageLabel.widthAnchor),
            createActivityButton.heightAnchor.constraint(equalTo: createActivityButton.widthAnchor, multiplier: 55 / 245),
            createActivityButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
