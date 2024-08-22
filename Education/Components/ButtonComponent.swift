//
//  ButtonComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/07/24.
//

import UIKit

class ButtonComponent: UIButton {
    init(title: String, titleColor: UIColor?) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = .systemGray3
        self.layer.cornerRadius = 14
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
