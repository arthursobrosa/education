//
//  ButtonComponent.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/07/24.
//

import UIKit

class ButtonComponent: UIButton {
    init(title: String, textColor: UIColor? = .systemBackground, cornerRadius: CGFloat) {
        super.init(frame: .zero)

        let attributedString = NSAttributedString(string: title, attributes: [.font: UIFont(name: Fonts.darkModeOnSemiBold, size: 17) ?? .systemFont(ofSize: 17), .foregroundColor: textColor ?? .label])
        setAttributedTitle(attributedString, for: .normal)
        backgroundColor = .label
        layer.cornerRadius = cornerRadius
    }

    init(attrString: NSMutableAttributedString, textColor: UIColor? = .systemBackground, cornerRadius: CGFloat = 30) {
        super.init(frame: .zero)

        attrString.addAttribute(.font, value: UIFont(name: Fonts.darkModeOnSemiBold, size: 17) ?? .systemFont(ofSize: 17), range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(.foregroundColor, value: textColor ?? .label, range: NSRange(location: 0, length: attrString.length))

        setAttributedTitle(attrString, for: .normal)
        backgroundColor = .label
        layer.cornerRadius = cornerRadius
    }

    init(insets: NSDirectionalEdgeInsets, title: String, textColor: UIColor? = .systemBackground, fontStyle: String, fontSize: CGFloat, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        configuration.titlePadding = 10
        configuration.contentInsets = insets
        let attributedString = NSAttributedString(string: title, attributes: [.font: UIFont(name: fontStyle, size: fontSize) ?? .systemFont(ofSize: 17), .foregroundColor: textColor ?? .label])
        setAttributedTitle(attributedString, for: .normal)
        backgroundColor = .label
        layer.cornerRadius = cornerRadius
        self.configuration = configuration
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
