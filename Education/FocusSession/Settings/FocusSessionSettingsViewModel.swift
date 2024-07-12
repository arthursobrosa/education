//
//  FocusSessionSettingsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import Foundation

class FocusSessionSettingsViewModel {
    private let subjectManager: SubjectManager
    
    // MARK: - Properties
    var selectedTime: TimeInterval = 0 // Variable to hold the selected time
    
    var subjects = ["None"]
    lazy var selectedSubject = self.subjects[0] {
        didSet {
            if selectedSubject == self.subjects[0] {
                self.subjectID = nil
            } else {
                if let subject = self.subjectManager.fetchSubject(withName: selectedSubject) {
                    self.subjectID = subject.unwrappedName
                }
            }
        }
    }
    
    var alarmWhenFinished: Bool = true
    var blockApps: Bool = false
    
    var subjectID: String? = nil
    
    init(subjectManager: SubjectManager = SubjectManager()) {
        self.subjectManager = subjectManager
        
        if let subjects = self.subjectManager.fetchSubjects() {
            let subjectsNames = subjects.map { $0.unwrappedName }
            self.subjects.append(contentsOf: subjectsNames)
        }
    }
    
    // MARK: - Methods
    func getTotalSeconds(fromDate date: Date) -> TimeInterval {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let selectedHour = calendar.component(.hour, from: date)
        let selectedMinutes = calendar.component(.minute, from: date)
        
        let currentTotalTime = currentHour * 3600 + currentMinutes * 60 + currentSeconds
        let selectedTotalTime = selectedHour * 3600 + selectedMinutes * 60
        
        let totalTime = selectedTotalTime - currentTotalTime
        
        return TimeInterval(totalTime)
    }
}
