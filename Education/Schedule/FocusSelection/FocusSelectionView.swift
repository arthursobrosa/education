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
    
    // MARK: - Properties
    private lazy var backButton: UIButton = {
        let bttn = UIButton()
        bttn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        bttn.tintColor = .label
        
        bttn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
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
        let bttn = ButtonComponent(title: String(localized: "continue"), textColor: .secondaryLabel)
        bttn.isEnabled = false
        
        bttn.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        bttn.backgroundColor = .secondaryLabel
        
        return bttn
    }()
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        
        let textColor: UIColor? = .secondaryLabel
        
        let attributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font : UIFont(name: Fonts.darkModeOnRegular, size: 16) ?? .systemFont(ofSize: 18), .foregroundColor : textColor ?? .label])
        bttn.setAttributedTitle(attributedString, for: .normal)
        
        bttn.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.systemBackground
        self.layer.cornerRadius = 12

        self.setupUI()
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            guard let selected = self.lastSelected else { return }
                self.didTapSelectionButton(selected)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    private func changeButtonColors(_ button: UIButton, isSelected: Bool) {
        let color: UIColor = isSelected ? .label : .systemGray6
        button.layer.borderColor = color.cgColor
        
        continueButton.backgroundColor = .label
        let attributedString = NSAttributedString(string: continueButton.titleLabel!.text!, attributes: [.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor : UIColor.systemBackground])
        continueButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @objc private func didTapSelectionButton(_ sender: UIButton) {
        self.continueButton.isEnabled = true
        
        var selectionButtons = self.subviews.compactMap { $0 as? SelectionButton }
        
        if let buttonIndex = selectionButtons.firstIndex(where: { $0.tag == sender.tag }) {
            selectionButtons.remove(at: buttonIndex)
            
            self.changeButtonColors(sender, isSelected: true)
            
            for selectionButton in selectionButtons {
                self.changeButtonColors(selectionButton, isSelected: false)
            }
        }
        
        self.delegate?.selectionButtonTapped(tag: sender.tag)
        
        lastSelected = sender
    }
    
    @objc private func didTapContinueButton() {
        self.delegate?.continueButtonTapped()
    }
    
    @objc private func didTapCancelButton() {
        self.delegate?.dismissAll()
    }
    
    @objc private func didTapBackButton() {
        self.delegate?.dismiss()
    }
}

// MARK: - UI Setup
extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(backButton)
        self.addSubview(topLabel)
        self.addSubview(timerButton)
        self.addSubview(pomodoroButton)
        self.addSubview(stopwatchButton)
        self.addSubview(continueButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            topLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (213/366)),
            
            timerButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding * 1.5),
            timerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (334/366)),
            timerButton.heightAnchor.constraint(equalTo: timerButton.widthAnchor, multiplier: (68/334)),
            timerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pomodoroButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: padding / 2),
            pomodoroButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            pomodoroButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            pomodoroButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            stopwatchButton.topAnchor.constraint(equalTo: pomodoroButton.bottomAnchor, constant: padding / 2),
            stopwatchButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            stopwatchButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            stopwatchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            continueButton.topAnchor.constraint(equalTo: stopwatchButton.bottomAnchor, constant: padding),
            continueButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (312/366)),
            continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: (60/334)),
            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: padding * 0.5),
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}

