//
//  SelectionButton.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import Foundation
import UIKit

class SelectionButton: UIButton {
    init(title: String, bold: String, color: UIColor?) {
        super.init(frame: .zero)
        
        self.layer.borderWidth = 1.4
        self.layer.borderColor =  UIColor.systemGray6.cgColor
        self.setTitleColor(.label, for: .normal)
        
        let attributedText = self.attributedText(withString: title, boldString: bold, normalFont: UIFont(name: Fonts.darkModeOnRegular, size: 14), boldFont: UIFont(name: Fonts.darkModeOnSemiBold, size: 16))
        
        self.setAttributedTitle(attributedText, for: .normal)
        self.backgroundColor = color
        self.layer.cornerRadius = 34
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attributedText(withString string: String, boldString: String, normalFont: UIFont?, boldFont: UIFont?) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: normalFont ?? .systemFont(ofSize: 20)])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldFont ?? UIFont.boldSystemFont(ofSize: 20)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}
