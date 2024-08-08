//
//  Test+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Test {
    var unwrappedID: String {
        return id ?? String()
    }
    
    var unwrappedRightQuestions: Int {
        return Int(rightQuestions)
    }
    
    var unwrappedTotalQuestions: Int {
        return Int(totalQuestions)
    }
    
    var unwrappedThemeID: String {
        return themeID ?? String()
    }
}
