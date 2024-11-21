//
//  FocusSelectionView.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionView: UIView {
    // MARK: - Delegate to connect with VC
    
    weak var delegate: FocusSelectionDelegate?
    
    // MARK: - Properties
    
    var lastSelected: UIButton?
    var subjectName: String

    // MARK: - UI Properties
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let image = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemText40
        button.addTarget(delegate, action: #selector(FocusSelectionDelegate.dismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = subjectName
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "timeCountingQuestion")
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .label
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timerButton: SelectionButton = {
        let button = SelectionButton(title: String(localized: "timerSelectionTitle"), bold: String(localized: "timerSelectionBold"), color: backgroundColor)
        button.tag = 0
        button.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var pomodoroButton: SelectionButton = {
        let button = SelectionButton(title: String(localized: "pomodoroSelectionTitle"), bold: String(localized: "pomodoroSelectionTitle"), color: backgroundColor)
        button.tag = 1
        button.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stopwatchButton: SelectionButton = {
        let button = SelectionButton(title: String(localized: "stopwatchSelectionTitle"), bold: String(localized: "stopwatchSelectionBold"), color: self.backgroundColor)
        button.tag = 2
        button.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var continueButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "continue"), textColor: .systemBackground, cornerRadius: 26)
        button.isEnabled = false
        button.backgroundColor = .systemGray4
        button.addTarget(delegate, action: #selector(FocusSelectionDelegate.continueButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let textColor: UIColor? = .secondaryLabel
        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        let attributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font: regularFont, .foregroundColor: textColor ?? .label])
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(delegate, action: #selector(FocusSelectionDelegate.dismissAll), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    init(subjectName: String?) {
        if let subjectName {
            let maxLenght = 25
            var formattedSubjectName = subjectName
            if subjectName.count >= maxLenght {
                formattedSubjectName = String(subjectName.prefix(25)) + "..."
            }
            self.subjectName = String(format: NSLocalizedString("activityOf", comment: ""), formattedSubjectName)
        } else {
            self.subjectName = String(localized: "subjectActivityImediate")
        }

        super.init(frame: .zero)

        backgroundColor = .systemBackground
        layer.cornerRadius = 24

        setupUI()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            guard let selected = self.lastSelected else { return }
            self.didTapSelectionButton(selected)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func changeButtonColors(_ button: UIButton, isSelected: Bool) {
        let color: UIColor = isSelected ? .label : .systemGray4
        button.layer.borderColor = color.cgColor

        continueButton.backgroundColor = .label
        let semiboldFont: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        if let continueButtonText = continueButton.titleLabel?.text {
            let attributedString = NSAttributedString(string: continueButtonText, attributes: [.font: semiboldFont, .foregroundColor: UIColor.systemBackground])
            continueButton.setAttributedTitle(attributedString, for: .normal)
        }
    }

    @objc 
    private func didTapSelectionButton(_ sender: UIButton) {
        continueButton.isEnabled = true

        var selectionButtons = subviews.compactMap { $0 as? SelectionButton }

        if let buttonIndex = selectionButtons.firstIndex(where: { $0.tag == sender.tag }) {
            selectionButtons.remove(at: buttonIndex)

            changeButtonColors(sender, isSelected: true)

            for selectionButton in selectionButtons {
                changeButtonColors(selectionButton, isSelected: false)
            }
        }

        delegate?.selectionButtonTapped(tag: sender.tag)

        lastSelected = sender
    }
    
    func changeContinueButtonText(isStarting: Bool) {
        if isStarting {
            let text = String(localized: "start")
            let font: UIFont = .init(name: Fonts.darkModeOnMedium, size: 17) ?? .systemFont(ofSize: 17, weight: .medium)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemModalBg,
                .font: font,
            ]
            let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
            
            let symbolAttachment = NSTextAttachment()
            let symbolImage = UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17)).withTintColor(.systemModalBg)
            symbolAttachment.image = symbolImage
            symbolAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
            
            let symbolAttributedString = NSAttributedString(attachment: symbolAttachment)
            
            attributedText.append(NSAttributedString(string: "   "))
            attributedText.append(symbolAttributedString)
            
            continueButton.setAttributedTitle(attributedText, for: .normal)
        } else {
            let text = String(localized: "continue")
            let font: UIFont = .init(name: Fonts.darkModeOnMedium, size: 17) ?? .systemFont(ofSize: 17, weight: .medium)
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemModalBg,
                .font: font,
            ]
            let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
            
            continueButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
}

// MARK: - UI Setup

extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(topLabel)
        addSubview(timerButton)
        addSubview(pomodoroButton)
        addSubview(stopwatchButton)
        addSubview(continueButton)
        addSubview(cancelButton)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 27 / 366),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            topLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            timerButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 39),
            timerButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 330 / 366),
            timerButton.heightAnchor.constraint(equalTo: timerButton.widthAnchor, multiplier: 72 / 330),
            timerButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            pomodoroButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: 8),
            pomodoroButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            pomodoroButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            pomodoroButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            stopwatchButton.topAnchor.constraint(equalTo: pomodoroButton.bottomAnchor, constant: 8),
            stopwatchButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            stopwatchButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            stopwatchButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            continueButton.topAnchor.constraint(equalTo: stopwatchButton.bottomAnchor, constant: 21),
            continueButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 330 / 366),
            continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: 55 / 330),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            cancelButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 16),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
        ])
    }
}
