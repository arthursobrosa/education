//
//  UIColor+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/08/24.
//

import UIKit

extension UIColor {
    func getDarkerColor() -> UIColor? {
        guard let components = self.cgColor.components else { return nil }
        
        let red = components[0] * 0.6
        let green = components[1] * 0.6
        let blue = components[2] * 0.6
        let alpha = components[3]
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func getSecondaryColor() -> UIColor? {
        guard let components = self.cgColor.components else { return nil }
        
        let red = components[0] * 0.8
        let green = components[1] * 0.8
        let blue = components[2] * 0.8
        let alpha = components[3]
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
