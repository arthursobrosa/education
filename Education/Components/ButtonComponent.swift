//
//  ButtonComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/07/24.
//

import UIKit

class ButtonComponent: UIButton {
    init(title: String, textColor: UIColor? = .systemBackground) {
        super.init(frame: .zero)
        
        let attributedString = NSAttributedString(string: title, attributes: [.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 18) ?? .systemFont(ofSize: 18), .foregroundColor : textColor ?? .label])
        self.setAttributedTitle(attributedString, for: .normal)
        self.backgroundColor = .label
        self.layer.cornerRadius = 30
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 18),
            self.widthAnchor.constraint(equalToConstant: 104),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
