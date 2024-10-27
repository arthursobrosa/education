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

        layer.borderWidth = 1.2
        layer.borderColor = UIColor.systemGray4.cgColor
        setTitleColor(.label, for: .normal)

        let attributedText = attributedText(
            withString: title,
            boldString: bold,
            normalFont: UIFont(name: Fonts.darkModeOnRegular, size: 14),
            boldFont: UIFont(name: Fonts.darkModeOnMedium, size: 17)
        )

        setAttributedTitle(attributedText, for: .normal)
        backgroundColor = color
        layer.cornerRadius = 34
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
