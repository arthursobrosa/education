//
//  ScheduleDetailsViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import Foundation

class ScheduleDetailsViewModel {
    // MARK: - Subject and Schedule Handlers
    private let subjectManager: SubjectManager
    private let scheduleManager: ScheduleManager
    
    // MARK: - Properties
    var subjectsNames: [String]
    var selectedSubjectName: String
    
    let days = [
        String(localized: "sunday"),
        String(localized: "monday"),
        String(localized: "tuesday"),
        String(localized: "wednesday"),
        String(localized: "thursday"),
        String(localized: "friday"),
        String(localized: "saturday")
    ]
    var selectedDay: String
    
    var selectedStartTime: Date
    var selectedEndTime: Date
    
    var alarmBefore: Bool
    var alarmInTime: Bool
    
    var blocksApps: Bool
    
    private var scheduleID: String?
    var schedule: Schedule?
    
    // MARK: - Initializer
    init(subjectManager: SubjectManager = SubjectManager(), scheduleManager: ScheduleManager = ScheduleManager(), schedule: Schedule? = nil, selectedDay: Int?) {
        self.subjectManager = subjectManager
        self.scheduleManager = scheduleManager
        self.schedule = schedule
        
        let currentDate = Date.now
        
        var selectedSubjectName: String = String()
        var selectedStartTime: Date = currentDate
        var selectedEndTime: Date = selectedStartTime.addingTimeInterval(60)
        var selectedDayIndex = selectedDay != nil ? selectedDay! : 0
        
        self.subjectsNames = [String]()
        
        if let subjects = self.subjectManager.fetchSubjects() {
            self.subjectsNames = subjects.map({ $0.unwrappedName })
            if !subjectsNames.isEmpty {
                selectedSubjectName = self.subjectsNames[0]
            }
        }
        
        self.alarmBefore = false
        self.alarmInTime = false
        
        if let schedule {
            if let subject = self.subjectManager.fetchSubject(withID: schedule.unwrappedSubjectID) {
                selectedSubjectName = subject.unwrappedName
            }
            
            selectedStartTime = schedule.unwrappedStartTime
            selectedEndTime = schedule.unwrappedEndTime
            self.alarmBefore = schedule.earlyAlarm
            self.alarmInTime = schedule.imediateAlarm
            selectedDayIndex = schedule.unwrappedDay
        }

        self.selectedDay = self.days[selectedDayIndex]
        self.selectedSubjectName = selectedSubjectName
        self.selectedStartTime = selectedStartTime
        self.selectedEndTime = selectedEndTime
        self.scheduleID = schedule?.unwrappedID
        self.blocksApps = schedule?.blocksApps ?? false
    }
    
    // MARK: - Methods
    func fetchSubjects() {
        if let subjects = self.subjectManager.fetchSubjects() {
            self.subjectsNames = subjects.map({ $0.unwrappedName })
        }
    }
    
    func addSubject(name: String) {
        self.subjectManager.createSubject(name: name, color: "FocusSelectionColor")
        self.fetchSubjects()
        self.selectedSubjectName = name
    }
    
    func saveSchedule() {
        if let scheduleID {
            self.updateSchedule(withID: scheduleID)
        } else {
            self.createNewSchedule()
        }
    }
    
    private func createNewSchedule() {
        guard let subject = self.subjectManager.fetchSubject(withName: self.selectedSubjectName) else { return }
        
        if let selectedIndex = self.days.firstIndex(where: { $0 == selectedDay }) {
            let dayOfTheWeek = Int(selectedIndex)
            handleAlerts()
            self.scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: dayOfTheWeek, startTime: self.selectedStartTime, endTime: self.selectedEndTime, blocksApps: self.blocksApps, earlyAlarm: self.alarmBefore, imediateAlarm: self.alarmInTime)
        }
    }
    
    private func handleAlerts() {
        let selectedDate = self.selectedStartTime
        let title = String(localized: "reminder")
        let bodyBefore = String(format: NSLocalizedString("comingEvent", comment: ""), String(selectedSubjectName))
        let bodyInTime = String(format: NSLocalizedString("imediateEvent", comment: ""), String(selectedSubjectName))
        
        if self.alarmBefore {
            NotificationService.shared.scheduleWeeklyNotification(
               title: title,
               body: bodyBefore,
               date: selectedDate
           )
        }
        
        if self.alarmInTime {
            NotificationService.shared.scheduleWeeklyNotificationAtExactTime(
               title: title,
               body: bodyInTime,
               date: selectedDate,
               subjectName: selectedSubjectName,
               startTime: selectedStartTime,
               endTime: selectedEndTime
           )
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
                    
                    NotificationService.shared.cancelNotifications(forDate: schedule.startTime!)
                    
                    schedule.startTime = self.selectedStartTime
                    schedule.endTime = self.selectedEndTime
                    schedule.blocksApps = self.blocksApps
                    schedule.earlyAlarm = self.alarmBefore
                    schedule.imediateAlarm = self.alarmInTime
                    
                    self.handleAlerts()
                }
            }
            
            self.scheduleManager.updateSchedule(schedule)
        }
    }
    
    func isNewScheduleAvailable() -> Bool {
        var isAvailable: Bool = true
        
        var allSchedules = [Schedule]()
        
        if let subjects = self.subjectManager.fetchSubjects() {
            subjects.forEach { subject in
                if let schedules = self.scheduleManager.fetchSchedules(subjectID: subject.unwrappedID) {
                    allSchedules.append(contentsOf: schedules)
                }
            }
        }
        
        var filteredSchedules = allSchedules
        
        if let selectedIndex = self.days.firstIndex(where: { $0 == self.selectedDay }) {
            let dayOfWeek = Int(selectedIndex)
            filteredSchedules = filteredSchedules.filter { $0.dayOfTheWeek == dayOfWeek }
        }
        
        if !filteredSchedules.isEmpty {
            isAvailable = self.isTimeSlotAvailable(existingSchedules: filteredSchedules)
        }
        
        return isAvailable
    }
    
    private func isTimeSlotAvailable(existingSchedules: [Schedule]) -> Bool {
        guard let newStartTime = self.formatDate(self.selectedStartTime),
              let newEndTime = self.formatDate(self.selectedEndTime) else { return false }
        
        for schedule in existingSchedules {
            if let existingStartTime = self.formatDate(schedule.unwrappedStartTime),
               let existingEndTime = self.formatDate(schedule.unwrappedEndTime) {
                if (newStartTime < existingEndTime && newEndTime > existingStartTime) {
                    if schedule.unwrappedID != self.scheduleID {
                        return false
                    }
                }
            }
            
            break
        }
        
        return true
    }
    
    private func getMinuteFrom(date: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: date).minute
    }
    
    private func getHourFrom(date: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: date).hour
    }
    
    private func formatDate(_ date: Date) -> Date? {
        guard let firstDateHour = self.getHourFrom(date: date),
              let firstDateMinute = self.getMinuteFrom(date: date) else { return nil }
        
        let dateComponents = DateComponents(
            year: 0,
            month: 1,
            hour: firstDateHour,
            minute: firstDateMinute,
            second: 0
        )
        
        guard let returnedDate = Calendar.current.date(from: dateComponents) else { return nil }
        
        return returnedDate
    }
    
    func getTitleName() -> String {
        let subject = self.subjectManager.fetchSubject(withID: self.schedule?.subjectID)
        
        let title: String

        if let name = subject?.name {
            title = "\(String(localized: "activityPre")) \(name) \(String(localized: "activityPost"))"
        } else {
            title = String(localized: "newActivity")
        }
        return title
    }
}
