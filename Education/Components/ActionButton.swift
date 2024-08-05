//
//  ActionButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/08/24.
//

import UIKit

class ActionButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.changeButtonState(isEnabled: isEnabled)
        }
    }
    
    private let firstLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.2
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let secondLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var thirdLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(title: String, titleColor: UIColor?) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.firstLayerView.layer.cornerRadius = self.firstLayerView.bounds.height / 2
        self.secondLayerView.layer.cornerRadius = self.secondLayerView.bounds.height / 2
        self.thirdLayerView.layer.cornerRadius = self.thirdLayerView.bounds.height / 2
    }
    
    private func changeButtonState(isEnabled: Bool) {
        let alpha = isEnabled ? 1 : 0.4
        
        self.thirdLayerView.alpha = alpha
    }
}

private extension ActionButton {
    func setupUI() {
        self.addSubview(firstLayerView)
        self.addSubview(secondLayerView)
        self.addSubview(thirdLayerView)
        
        NSLayoutConstraint.activate([
            firstLayerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            firstLayerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            firstLayerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            firstLayerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            secondLayerView.widthAnchor.constraint(equalTo: firstLayerView.widthAnchor, multiplier: (322/330)),
            secondLayerView.heightAnchor.constraint(equalTo: secondLayerView.widthAnchor, multiplier: (62/322)),
            secondLayerView.centerXAnchor.constraint(equalTo: firstLayerView.centerXAnchor),
            secondLayerView.centerYAnchor.constraint(equalTo: firstLayerView.centerYAnchor),
            
            thirdLayerView.widthAnchor.constraint(equalTo: secondLayerView.widthAnchor, multiplier: (312/322)),
            thirdLayerView.heightAnchor.constraint(equalTo: thirdLayerView.widthAnchor, multiplier: (52/312)),
            thirdLayerView.centerXAnchor.constraint(equalTo: secondLayerView.centerXAnchor),
            thirdLayerView.centerYAnchor.constraint(equalTo: secondLayerView.centerYAnchor),
        ])
    }
}
