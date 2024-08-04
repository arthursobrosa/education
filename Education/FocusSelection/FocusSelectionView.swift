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
    
    private lazy var timerButton: UIButton = {
        let bttn = SelectionButton(title: String("Tempo programado \n Ex.: 50 minutos"), bold: "Tempo programado")
        
        bttn.addTarget(self, action: #selector(didTapTimerButton(_:)), for: .touchUpInside)
        
        return bttn
    }()
    
    private lazy var stopWatchButton: UIButton = {
        let bttn = SelectionButton(title: String("Tempo programado com intervalo"), bold: String("Tempo programado com intervalo"))
        
        bttn.addTarget(self, action: #selector(didTapStopWatchButton(_:)), for: .touchUpInside)
        
        return bttn
    }()
    
    private lazy var pomodoroButton: UIButton = {
        let bttn = SelectionButton(title: String("Livre (pare quando quiser)"), bold: String("Livre"))
        
        bttn.addTarget(self, action: #selector(didTapPomodoroButton(_:)), for: .touchUpInside)
        
        return bttn
    }()
    
    private lazy var finishButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String("Continuar"))
        
        bttn.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        
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
    
    @objc private func didTapTimerButton(_ sender: UIButton) {
        self.changeButtonColors(sender, isSelected: true)
        self.changeButtonColors(self.pomodoroButton, isSelected: false)
        self.changeButtonColors(self.stopWatchButton, isSelected: false)
        
        self.delegate?.timerButtonTapped()
    }
    
    @objc private func didTapPomodoroButton(_ sender: UIButton) {
        self.changeButtonColors(sender, isSelected: true)
        self.changeButtonColors(self.timerButton, isSelected: false)
        self.changeButtonColors(self.stopWatchButton, isSelected: false)
        
        self.delegate?.pomodoroButtonTapped()
    }
    
    @objc private func didTapStopWatchButton(_ sender: UIButton) {
        self.changeButtonColors(sender, isSelected: true)
        self.changeButtonColors(self.pomodoroButton, isSelected: false)
        self.changeButtonColors(self.timerButton, isSelected: false)
        
        self.delegate?.stopWatchButtonTapped()
    }
    
    @objc private func didTapFinishButton() {
        self.delegate?.finishButtonTapped()
    }
}

// MARK: - UI Setup
extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(topLabel)
        self.addSubview(timerButton)
        self.addSubview(stopWatchButton)
        self.addSubview(pomodoroButton)
        self.addSubview(finishButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            timerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            timerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            timerButton.bottomAnchor.constraint(equalTo: stopWatchButton.topAnchor, constant: -padding),
            timerButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            stopWatchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stopWatchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stopWatchButton.bottomAnchor.constraint(equalTo: pomodoroButton.topAnchor, constant: -padding),
            stopWatchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            pomodoroButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            pomodoroButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            pomodoroButton.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -padding),
            pomodoroButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            finishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            finishButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            finishButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            finishButton.heightAnchor.constraint(equalTo: finishButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
