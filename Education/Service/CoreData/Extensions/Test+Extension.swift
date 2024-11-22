//
//  Test+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension Test {
    var unwrappedID: String {
        id ?? String()
    }

    var unwrappedRightQuestions: Int {
        Int(rightQuestions)
    }

    var unwrappedTotalQuestions: Int {
        Int(totalQuestions)
    }

    var unwrappedThemeID: String {
        themeID ?? String()
    }

    var unwrappedDate: Date {
        date ?? Date()
    }

    var unwrappedComment: String {
        comment ?? String()
    }
}
