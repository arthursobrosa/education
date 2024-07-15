//
//  ScheduleDetailsViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import Foundation

class ScheduleDetailsViewModel {
    private let subjectManager: SubjectManager
    private let scheduleManager: ScheduleManager
    
    var subjectsNames: [String]
    var selectedSubjectName: String
    
    var days: [String]
    var selectedDay: String
    
    var selectedStartTime: Date
    var selectedEndTime: Date
    
    private var scheduleID: String?
    
    init(subjectManager: SubjectManager = SubjectManager(), scheduleManager: ScheduleManager = ScheduleManager(), schedule: Schedule? = nil) {
        self.subjectManager = subjectManager
        self.scheduleManager = scheduleManager
        
        self.days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        var selectedWeekday: Int = 0
        var selectedSubjectName: String = String()
        var selectedStartTime: Date = Date()
        var selectedEndTime: Date = Date()
        
        self.subjectsNames = [String]()
        
        if let subjects = self.subjectManager.fetchSubjects() {
            self.subjectsNames = subjects.map({ $0.unwrappedName })
            if !subjectsNames.isEmpty {
                selectedSubjectName = self.subjectsNames[0]
            }
        }
        
        if let schedule = schedule {
            selectedWeekday = schedule.unwrappedDay
            
            if let subject = self.subjectManager.fetchSubject(withID: schedule.unwrappedSubjectID) {
                selectedSubjectName = subject.unwrappedName
            }
            
            selectedStartTime = schedule.unwrappedStartTime
            selectedEndTime = schedule.unwrappedEndTime
        }
        
        self.selectedDay = self.days[selectedWeekday]
        self.selectedSubjectName = selectedSubjectName
        self.selectedStartTime = selectedStartTime
        self.selectedEndTime = selectedEndTime
        self.scheduleID = schedule?.unwrappedID
    }
    
    func fetchSubjects() {
        if let subjects = self.subjectManager.fetchSubjects() {
            self.subjectsNames = subjects.map({ $0.unwrappedName })
        }
    }
    
    func addSubject(name: String) {
        self.subjectManager.createSubject(name: name)
        self.fetchSubjects()
        self.selectedSubjectName = name
    }
    
    func saveSchedule() {
        if let scheduleID = scheduleID {
            self.updateSchedule(withID: scheduleID)
        } else {
            self.createNewSchedule()
        }
    }
    
    private func createNewSchedule() {
        guard let subject = self.subjectManager.fetchSubject(withName: self.selectedSubjectName) else { return }
        
        if let selectedIndex = self.days.firstIndex(where: { $0 == selectedDay }) {
            let dayOfTheWeek = Int(selectedIndex)
            self.scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: dayOfTheWeek, startTime: self.selectedStartTime, endTime: self.selectedEndTime)
        }
    }
    
    private func updateSchedule(withID id: String) {
        if let schedule = self.scheduleManager.fetchSchedule(from: id) {
            if let subjects = self.subjectManager.fetchSubjects() {
                if let subject = subjects.first(where: { $0.unwrappedName == self.selectedSubjectName }) {
                    schedule.subjectID = subject.unwrappedID
                    
                    if let dayOfTheWeek = self.days.firstIndex(where: { $0 == self.selectedDay }) {
                        schedule.dayOfTheWeek = Int16(dayOfTheWeek)
                    }
                    
                    schedule.startTime = self.selectedStartTime
                    schedule.endTime = self.selectedEndTime
                }
            }
            
            self.scheduleManager.updateSchedule(schedule)
        }
    }
}
