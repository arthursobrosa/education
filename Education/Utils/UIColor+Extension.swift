//
//  UIColor+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/08/24.
//

import UIKit

extension UIColor {
    func darker(by percentage: CGFloat) -> UIColor? {
        guard let components = self.cgColor.components else { return nil }

        let red = components[0] * percentage
        let green = components[1] * percentage
        let blue = components[2] * percentage
        let alpha = components[3]

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
