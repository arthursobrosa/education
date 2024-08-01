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
    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "De que forma você deseja contar o tempo?"
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20)
        lbl.textColor = .label
        lbl.numberOfLines = 2
        
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
    
    lazy var finishButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String("Continuar"))
        bttn.isEnabled = false
        bttn.alpha = 0.5
        
        bttn.addTarget(self, action: #selector(didTapFinishButton(_:)), for: .touchUpInside)
        
        return bttn
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Auxiliar methods
    
    @objc private func didTapTimerButton(_ sender: UIButton) {
        self.delegate?.timerButtonTapped()
    }
    
    @objc private func didTapPomodoroButton(_ sender: UIButton) {
        self.delegate?.pomodoroButtonTapped()
    }
    
    @objc private func didTapStopWatchButton(_ sender: UIButton) {
        self.delegate?.stopWatchButtonTapped()
    }
    
    @objc private func didTapFinishButton(_ sender: UIButton) {
        self.delegate?.timerButtonTapped()
    }
    
}

// MARK: - UI Setup
extension FocusSelectionView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerContainerView)
        timerContainerView.addSubview(topLabel)
        
        self.addSubview(timerButton)
        self.addSubview(pomodoroButton)
        self.addSubview(stopWatchButton)
        self.addSubview(finishButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            timerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding * 2),
            timerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.385),
            timerContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            timerContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            timerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            timerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            timerButton.bottomAnchor.constraint(equalTo: pomodoroButton.topAnchor, constant: -padding),
            timerButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            pomodoroButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            pomodoroButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            pomodoroButton.bottomAnchor.constraint(equalTo: stopWatchButton.topAnchor, constant: -padding),
            pomodoroButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            stopWatchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stopWatchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stopWatchButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding * 5),
            stopWatchButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.184),
            
            finishButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            finishButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            finishButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            finishButton.heightAnchor.constraint(equalTo: finishButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
