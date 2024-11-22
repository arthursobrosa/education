//
//  FocusImediateViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import Foundation

class FocusImediateViewModel {
    private let subjectManager: SubjectManager

    var subjects = Box([Subject]())

    init(subjectManager: SubjectManager = SubjectManager()) {
        self.subjectManager = subjectManager
    }

    func fetchSubjects() {
        if let subjects = subjectManager.fetchSubjects() {
            self.subjects.value = subjects
        }
    }
}
