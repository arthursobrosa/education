//
//  FocusSelectionView.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionView: UIView {
    weak var delegate: FocusSelectionDelegate?
    var lastSelected: UIButton?
    var subjectName: String

    // MARK: - Properties

    private lazy var backButton: UIButton = {
        let bttn = UIButton()
        bttn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        bttn.tintColor = .label

        bttn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = subjectName
        lbl.textAlignment = .center
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        lbl.textColor = .label

        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = String(localized: "timeCountingQuestion")
        lbl.textAlignment = .center
        lbl.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        lbl.textColor = .label
        lbl.numberOfLines = -1
        lbl.lineBreakMode = .byWordWrapping

        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    private lazy var timerButton: SelectionButton = {
        let bttn = SelectionButton(title: String(localized: "timerSelectionTitle"), bold: String(localized: "timerSelectionBold"), color: self.backgroundColor)
        bttn.tag = 0

        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var pomodoroButton: SelectionButton = {
        let bttn = SelectionButton(title: String(localized: "pomodoroSelectionTitle"), bold: String(localized: "pomodoroSelectionTitle"), color: self.backgroundColor)
        bttn.tag = 1

        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var stopwatchButton: SelectionButton = {
        let bttn = SelectionButton(title: String(localized: "stopwatchSelectionTitle"), bold: String(localized: "stopwatchSelectionBold"), color: self.backgroundColor)
        bttn.tag = 2

        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var continueButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "continue"), textColor: .systemBackground, cornerRadius: 26)
        bttn.isEnabled = false
        bttn.backgroundColor = .systemGray4

        bttn.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())

        let textColor: UIColor? = .secondaryLabel

        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        let attributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font: regularFont, .foregroundColor: textColor ?? .label])
        bttn.setAttributedTitle(attributedString, for: .normal)

        bttn.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
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

        backgroundColor = UIColor.systemBackground
        layer.cornerRadius = 12

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

    // MARK: - Auxiliar methods

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

    @objc 
    private func didTapContinueButton() {
        delegate?.continueButtonTapped()
    }

    @objc 
    private func didTapCancelButton() {
        delegate?.dismissAll()
    }

    @objc 
    private func didTapBackButton() {
        delegate?.dismiss()
    }
}

// MARK: - UI Setup

extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        addSubview(backButton)
        addSubview(nameLabel)
        addSubview(topLabel)
        addSubview(timerButton)
        addSubview(pomodoroButton)
        addSubview(stopwatchButton)
        addSubview(continueButton)
        addSubview(cancelButton)

        let padding = 20.0

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),

            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            topLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            topLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            topLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 270 / 366),

            timerButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding * 1.5),
            timerButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            timerButton.heightAnchor.constraint(equalTo: timerButton.widthAnchor, multiplier: 68 / 334),
            timerButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            pomodoroButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: padding / 2),
            pomodoroButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            pomodoroButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            pomodoroButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            stopwatchButton.topAnchor.constraint(equalTo: pomodoroButton.bottomAnchor, constant: padding / 2),
            stopwatchButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            stopwatchButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            stopwatchButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            continueButton.topAnchor.constraint(equalTo: stopwatchButton.bottomAnchor, constant: padding),
            continueButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: 55 / 334),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            cancelButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: padding * 0.5),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }
}
