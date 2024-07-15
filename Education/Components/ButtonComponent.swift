//
//  ButtonComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/07/24.
//

import UIKit

class ButtonComponent: UIButton {
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(.label, for: .normal)
        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 14
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
