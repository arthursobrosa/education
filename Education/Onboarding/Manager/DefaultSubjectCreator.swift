//
//  DefaultSubjectCreator.swift
//  Education
//
//  Created by Eduardo Dalencon on 14/11/24.
//

import Foundation

class DefaultSubjectCreator {
    private let subjectManager = SubjectManager()
    private let subjectColors = [
        "bluePicker",
        "blueSkyPicker",
        "olivePicker",
        "orangePicker",
        "pinkPicker",
        "redPicker",
        "turquoisePicker",
        "violetPicker",
        "yellowPicker",
    ]
    
    private var defaultSubjects = [
        String(localized: "subject_portuguese"),
        String(localized: "subject_literature"),
        String(localized: "subject_english"),
        String(localized: "subject_arts"),
        String(localized: "subject_physical_education"),
        String(localized: "subject_it"),
        String(localized: "subject_history"),
        String(localized: "subject_geography"),
        String(localized: "subject_philosophy"),
        String(localized: "subject_sociology"),
        String(localized: "subject_chemistry"),
        String(localized: "subject_physics"),
        String(localized: "subject_biology"),
        String(localized: "subject_mathematics"),
    ]
    
    func fetchSubjectNames() -> [String] {
        return defaultSubjects.sorted()
    }
    
    func addSubjectName(_ name: String) {
        if !defaultSubjects.contains(name) {
            defaultSubjects.append(name)
        }
    }
    
    func createDefaultSubjects(subjectNames: [String]) {
        for subject in subjectNames {
            subjectManager.createSubject(name: subject, color: selectAvailableColor())
        }
    }
    
    func fetchSubjects() -> [Subject]? {
        guard let subjects = subjectManager.fetchSubjects() else { return nil }
        
        let sortedSubjects = subjects.sorted(by: { $0.unwrappedName < $1.unwrappedName })
        
        return sortedSubjects
    }
    
    func removeSujects() {
        guard let subjects = subjectManager.fetchSubjects() else { return }
        
        subjects.forEach { subject in
            subjectManager.deleteSubject(subject)
        }
    }
    
    private func selectAvailableColor() -> String {
        let existingSubjects = subjectManager.fetchSubjects() ?? []

        let usedColors = Set(existingSubjects.map { $0.unwrappedColor })

        for color in subjectColors where !usedColors.contains(color) {
            return color
        }

        return subjectColors.first ?? "bluePicker"
    }
}
