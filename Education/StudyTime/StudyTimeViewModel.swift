//
//  StudyTimeViewModel.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeViewModel {
    let subjectmanager: SubjectManager
    
    init(subjectmanager: SubjectManager = SubjectManager()) {
        self.subjectmanager = subjectmanager
    }
    
    var subjects = Box([Subject]())
    
    func fetchSubjects() {
//        addSubjects()
        if let subjects = self.subjectmanager.fetchSubjects() {
            self.subjects.value = subjects
        }
    }
//    func addSubjects() {
//        self.subjectmanager.createSubject(name: "Matematica")
//        self.subjectmanager.createSubject(name: "Portugues")
//        self.subjectmanager.createSubject(name: "Biologia")
//        self.subjectmanager.createSubject(name: "historia")
//        self.subjectmanager.createSubject(name: "Literatura")
//        self.subjectmanager.createSubject(name: "Artes")
//    }
    
    func removeSubject(subject: Subject) {
        self.subjectmanager.deleteSubject(subject)
        self.fetchSubjects()
    }
}
