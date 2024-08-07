//
//  FocusSelectionView.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionView: UIView {
    weak var delegate: FocusSelectionDelegate?
    
    // MARK: - Properties
    private lazy var backButton: UIButton = {
        let bttn = UIButton()
        bttn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        bttn.tintColor = .white
        
        bttn.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "De que forma você deseja contar o tempo?"
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        lbl.textColor = .white
        lbl.numberOfLines = -1
        lbl.lineBreakMode = .byWordWrapping
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var timerButton: SelectionButton = {
        let bttn = SelectionButton(title: String("Tempo programado \n Ex.: 50 minutos"), bold: "Tempo programado", color: self.backgroundColor)
        bttn.tag = 0
        
        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var stopWatchButton: SelectionButton = {
        let bttn = SelectionButton(title: String("Tempo programado com intervalo"), bold: String("Tempo programado com intervalo"), color: self.backgroundColor)
        bttn.tag = 1
        
        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var pomodoroButton: SelectionButton = {
        let bttn = SelectionButton(title: String("Livre (pare quando quiser)"), bold: String("Livre"), color: self.backgroundColor)
        bttn.tag = 2
        
        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var continueButton: ActionButton = {
        let titleColor = self.backgroundColor?.getDarkerColor()
        let bttn = ActionButton(title: "Continuar", titleColor: titleColor)
        bttn.isEnabled = false
        
        bttn.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        bttn.setTitle("Cancel", for: .normal)
        bttn.setTitleColor(self.backgroundColor?.getDarkerColor(), for: .normal)
        
        bttn.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    // MARK: - Initializer
    init(color: UIColor?) {
        super.init(frame: .zero)
        
        self.backgroundColor = color
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    private func changeButtonColors(_ button: UIButton, isSelected: Bool) {
        let color: UIColor = isSelected ? .white : .black
        
        button.setTitleColor(color, for: .normal)
        button.layer.borderColor = color.cgColor
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
    }
    
    @objc private func didTapContinueButton() {
        self.delegate?.continueButtonTapped()
    }
    
    @objc private func didTapCancelButton() {
        self.delegate?.dismiss()
    }
    
    @objc private func didTapBackButton() {
        self.delegate?.dismiss()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.borderWidth = 1
    }
}

// MARK: - UI Setup
extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(backButton)
        self.addSubview(topLabel)
        self.addSubview(timerButton)
        self.addSubview(stopWatchButton)
        self.addSubview(pomodoroButton)
        self.addSubview(continueButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            topLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (213/359)),
            
            timerButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding / 2),
            timerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (319/359)),
            timerButton.heightAnchor.constraint(equalTo: timerButton.widthAnchor, multiplier: (108/319)),
            timerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            stopWatchButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: padding / 2),
            stopWatchButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            stopWatchButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            stopWatchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pomodoroButton.topAnchor.constraint(equalTo: stopWatchButton.bottomAnchor, constant: padding / 2),
            pomodoroButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor),
            pomodoroButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor),
            pomodoroButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            continueButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (330/359)),
            continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: (70/330)),
            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: padding * 0.7),
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}
