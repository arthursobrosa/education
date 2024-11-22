//
//  FocusPickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerView: UIView {
    // MARK: - Delegate to connect with VC
    
    weak var delegate: FocusPickerDelegate?

    // MARK: - Properties
    
    private let timerCase: TimerCase

    // MARK: - UI Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .systemText40
        button.addTarget(delegate, action: #selector(FocusPickerDelegate.dismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemText
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateView: DateView = {
        let view = DateView(timerCase: self.timerCase)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var startButton: ButtonComponent = {
        let titleName = String(localized: "start")
        let font: UIFont = .init(name: Fonts.darkModeOnMedium, size: 17) ?? .systemFont(ofSize: 17, weight: .medium)
        let color: UIColor = .systemModalBg
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let attributedText = NSMutableAttributedString(string: titleName, attributes: attributes)

        let symbolAttachment = NSTextAttachment()
        let symbolImage = UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17)).withTintColor(.systemModalBg)
        symbolAttachment.image = symbolImage
        symbolAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)

        let symbolAttributedString = NSAttributedString(attachment: symbolAttachment)

        attributedText.append(NSAttributedString(string: "   "))
        attributedText.append(symbolAttributedString)

        let bttn = ButtonComponent(attrString: attributedText, cornerRadius: 26)
        bttn.setAttributedTitle(attributedText, for: .normal)

        bttn.addTarget(delegate, action: #selector(FocusPickerDelegate.startButtonTapped), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(configuration: .plain())

        let textColor: UIColor? = .secondaryLabel

        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        let attributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font: regularFont, .foregroundColor: textColor ?? .label])
        button.setAttributedTitle(attributedString, for: .normal)

        button.addTarget(delegate, action: #selector(FocusPickerDelegate.dismissAll), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // MARK: - Initializer
    
    init(timerCase: TimerCase) {
        self.timerCase = timerCase

        super.init(frame: .zero)

        backgroundColor = .systemModalBg
        layer.cornerRadius = 24

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func changeStartButtonState(isEnabled: Bool) {
        startButton.isEnabled = isEnabled
        startButton.backgroundColor = isEnabled ? .label : .systemGray4
    }
}

// MARK: - UI Setup

extension FocusPickerView: ViewCodeProtocol {
    func setupUI() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(dateView)
        addSubview(settingsTableView)
        addSubview(startButton)
        addSubview(cancelButton)

        var widthMultiplier = Double()
        var heightMultiplier = Double()

        switch timerCase {
        case .timer:
            widthMultiplier = 170 / 359
            heightMultiplier = 162 / 170
        case .pomodoro:
            widthMultiplier = 302 / 359
            heightMultiplier = 293 / 302
        default:
            break
        }

        let padding = 20.0

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            dateView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier),
            dateView.heightAnchor.constraint(equalTo: dateView.widthAnchor, multiplier: heightMultiplier),
            dateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: padding),

            settingsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalTo: settingsTableView.widthAnchor, multiplier: 168 / 366),
            settingsTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsTableView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: padding),

            startButton.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: padding),
            startButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 55 / 334),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            cancelButton.topAnchor.constraint(equalTo: startButton.bottomAnchor),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 55 / 334),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
