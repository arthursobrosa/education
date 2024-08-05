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
    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "De que forma você deseja contar o tempo?"
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textColor = .white
        lbl.numberOfLines = -1
        lbl.lineBreakMode = .byWordWrapping
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var timerButton: SelectionButton = {
        let bttn = SelectionButton(title: String("Tempo programado \n Ex.: 50 minutos"), bold: "Tempo programado")
        bttn.tag = 0
        
        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var stopWatchButton: SelectionButton = {
        let bttn = SelectionButton(title: String("Tempo programado com intervalo"), bold: String("Tempo programado com intervalo"))
        bttn.tag = 1
        
        bttn.addTarget(self, action: #selector(didTapSelectionButton(_:)), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var pomodoroButton: SelectionButton = {
        let bttn = SelectionButton(title: String("Livre (pare quando quiser)"), bold: String("Livre"))
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
        bttn.setTitle("Cancel", for: .normal)
        bttn.setTitleColor(self.backgroundColor?.getDarkerColor(), for: .normal)
        
        bttn.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: "FocusSelectionColor")
        
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
        self.delegate?.cancelButtonTapped()
    }
}

// MARK: - UI Setup
extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(topLabel)
        self.addSubview(timerButton)
        self.addSubview(stopWatchButton)
        self.addSubview(pomodoroButton)
        self.addSubview(continueButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            timerButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding),
            timerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            timerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            timerButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            stopWatchButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: padding),
            stopWatchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stopWatchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stopWatchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            pomodoroButton.topAnchor.constraint(equalTo: stopWatchButton.bottomAnchor, constant: padding),
            pomodoroButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            pomodoroButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            pomodoroButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            continueButton.topAnchor.constraint(equalTo: pomodoroButton.bottomAnchor, constant: padding),
            continueButton.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(padding * 2)),
            continueButton.heightAnchor.constraint(equalTo: continueButton.widthAnchor, multiplier: (70/330)),
            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: padding),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            cancelButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
}
