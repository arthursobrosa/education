//
//  SelectionButton.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import Foundation
import UIKit

class SelectionButton: UIButton {
    init(title: String, bold: String) {
        super.init(frame: .zero)
        
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitleColor(.black, for: .normal)
        
        let attributedText = attributedText(withString: title, boldString: bold, normalFont: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16))
        
        self.setAttributedTitle(attributedText, for: .normal)
        self.backgroundColor = UIColor(named: "FocusSelectionColor")
        self.layer.cornerRadius = 14
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func attributedText(withString string: String, boldString: String, normalFont: UIFont?, boldFont: UIFont?) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font: normalFont ?? .systemFont(ofSize: 20)])
    let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldFont ?? UIFont.boldSystemFont(ofSize: 20)]
    let range = (string as NSString).range(of: boldString)
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}
