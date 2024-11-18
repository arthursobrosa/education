//
//  OnboardingManagerViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/11/24.
//

import Foundation

class OnboardingManagerViewModel {
    // MARK: - Properties
    
    private let defaultSubjectCreator = DefaultSubjectCreator()
    var subjectNames: Box<[String]> = Box([])
    var selectedSubjectNames: [String] = []
    
    // MARK: - Methods
    
    func fetchSubjectNames() {
        subjectNames.value = defaultSubjectCreator.fetchSubjectNames()
    }
    
    func addSubjectName(fromSubjectIndex index: Int) {
        let subjectName = subjectNames.value[index]
        selectedSubjectNames.append(subjectName)
    }
    
    func removeSubjectName(fromSubjectIndex index: Int) {
        let subjectName = subjectNames.value[index]
        
        if let subjectIndex = selectedSubjectNames.firstIndex(where: { $0 == subjectName }) {
            selectedSubjectNames.remove(at: subjectIndex)
        }
    }
    
    func createNewSubjectName(_ name: String) {
        defaultSubjectCreator.addSubjectName(name)
        fetchSubjectNames()
    }
    
    func createSubjects() {
        defaultSubjectCreator.createDefaultSubjects(subjectNames: selectedSubjectNames)
    }
    
    func formattedSubjects() -> [(name: String, colorName: String)] {
        guard let subjects = defaultSubjectCreator.fetchSubjects() else { return [] }
        
        return subjects.map { ($0.unwrappedName, $0.unwrappedColor) }
    }
    
    func removeSubjects() {
        defaultSubjectCreator.removeSujects()
    }
    
    func isSelected(atIndex index: Int) -> Bool {
        let subjectName = subjectNames.value[index]
        
        for selectedSubjectName in selectedSubjectNames {
            if subjectName == selectedSubjectName {
                return true
            }
        }
        
        return false
    }
    
    func resetSelectedNames() {
        guard let fetchedSubjects = defaultSubjectCreator.fetchSubjects() else { return }
        
        let fetchedSubjectNames = fetchedSubjects.map { $0.unwrappedName }
        
        selectedSubjectNames = []
        
        for fetchedSubjectName in fetchedSubjectNames {
            if let selectedSubjectName = subjectNames.value.first(where: { $0 == fetchedSubjectName }) {
                selectedSubjectNames.append(selectedSubjectName)
            }
        }
    }
}
