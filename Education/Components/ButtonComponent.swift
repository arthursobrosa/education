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
    }
    
    init(attrString: NSMutableAttributedString, textColor: UIColor? = .systemBackground) {
        super.init(frame: .zero)
        
        attrString.addAttribute(.font, value: UIFont(name: Fonts.darkModeOnSemiBold, size: 18) ?? .systemFont(ofSize: 18), range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(.foregroundColor, value: textColor ?? .label, range: NSRange(location: 0, length: attrString.length))
        
        self.setAttributedTitle(attrString, for: .normal)
        self.backgroundColor = .label
        self.layer.cornerRadius = 30
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
