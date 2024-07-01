//
//  ThemeRightQuestionsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation

class ThemeRightQuestionsViewModel {
    
    func addNewItem(id: String, date: Date, rightQuestions: Int, totalQuestions: Int) {
        CoreDataManager.shared.createTest(themeID: id, date: date, rightQuestions: rightQuestions, totalQuestions: totalQuestions)
    }
}
