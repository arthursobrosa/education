//
//  ButtonComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/07/24.
//

import UIKit

class ButtonComponent: UIButton {
    init(title: String, textColor: UIColor? = .label) {
        super.init(frame: .zero)
        
        let attributedString = NSAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : textColor ?? .label])
        
        self.setAttributedTitle(attributedString, for: .normal)
        self.backgroundColor = .systemGray3
        self.layer.cornerRadius = 14
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
