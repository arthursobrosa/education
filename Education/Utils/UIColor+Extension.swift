//
//  UIColor+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/08/24.
//

import UIKit

extension UIColor {
    func darker(by percentage: CGFloat) -> UIColor? {
        guard let components = cgColor.components else { return nil }

        let red = components[0] * percentage
        let green = components[1] * percentage
        let blue = components[2] * percentage
        let alpha = components[3]

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // swiftlint: disable identifier_name
    func opaqueColor(on background: UIColor = .systemBackground) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        background.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let red = r1 * a1 + r2 * (1 - a1)
        let green = g1 * a1 + g2 * (1 - a1)
        let blue = b1 * a1 + b2 * (1 - a1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    // swiftlint: enable identifier_name
}
