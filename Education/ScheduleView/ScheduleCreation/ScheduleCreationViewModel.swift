//
//  ScheduleCreationViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import Foundation

class ScheduleCreationViewModel {
    private let subjectManager: SubjectManager
    private let scheduleManager: ScheduleManager
    
    var subjectsNames = [String]() {
        didSet {
            if !subjectsNames.isEmpty {
                self.selectedSubjectName = subjectsNames[0]
            }
        }
    }
    var selectedSubjectName = String()
    
    var days: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    lazy var selectedDay = self.days[0]
    
    var selectedStartTime = Date()
    var selectedEndTime = Date()
    
    init(subjectManager: SubjectManager = SubjectManager(), scheduleManager: ScheduleManager = ScheduleManager()) {
        self.subjectManager = subjectManager
        self.scheduleManager = scheduleManager
        
        self.fetchSubjects()
    }
    
    func fetchSubjects() {
        if let subjects = self.subjectManager.fetchSubjects() {
            self.subjectsNames = subjects.map({ $0.unwrappedName })
        }
    }
    
    func addSubject(name: String) {
        self.subjectManager.createSubject(name: name)
        self.fetchSubjects()
    }
    
    func addSchedule() {
        guard let subject = self.subjectManager.fetchSubject(withName: self.selectedSubjectName) else { return }
        
        if let selectedIndex = self.days.firstIndex(where: { $0 == selectedDay }) {
            let dayOfTheWeek = Int(selectedIndex)
            self.scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: dayOfTheWeek, startTime: self.selectedStartTime, endTime: self.selectedEndTime)
        }
    }
}
