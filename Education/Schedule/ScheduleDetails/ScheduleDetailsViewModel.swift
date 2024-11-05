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

    private let notificationService: NotificationServiceProtocol?

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
        String(localized: "saturday"),
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

    init(subjectManager: SubjectManager = SubjectManager(), 
         scheduleManager: ScheduleManager = ScheduleManager(),
         notificationService: NotificationServiceProtocol?,
         schedule: Schedule? = nil,
         selectedDay: Int?) {
        
        self.subjectManager = subjectManager
        self.scheduleManager = scheduleManager
        self.notificationService = notificationService
        self.schedule = schedule

        let currentDate = Date.now

        var selectedSubjectName = String()
        var selectedStartTime: Date = currentDate
        var selectedEndTime: Date = selectedStartTime.addingTimeInterval(60)
        var selectedDayIndex: Int = selectedDay ?? 0

        subjectsNames = [String]()

        if let subjects = self.subjectManager.fetchSubjects() {
            subjectsNames = subjects.map { $0.unwrappedName }
            if !subjectsNames.isEmpty {
                selectedSubjectName = subjectsNames[0]
            }
        }

        alarmBefore = false
        alarmInTime = false

        if let schedule {
            if let subject = self.subjectManager.fetchSubject(withID: schedule.unwrappedSubjectID) {
                selectedSubjectName = subject.unwrappedName
            }

            selectedStartTime = schedule.unwrappedStartTime
            selectedEndTime = schedule.unwrappedEndTime
            alarmBefore = schedule.earlyAlarm
            alarmInTime = schedule.imediateAlarm
            selectedDayIndex = schedule.unwrappedDay
        }

        self.selectedDay = days[selectedDayIndex]
        self.selectedSubjectName = selectedSubjectName
        self.selectedStartTime = selectedStartTime
        self.selectedEndTime = selectedEndTime
        scheduleID = schedule?.unwrappedID
        blocksApps = schedule?.blocksApps ?? false
    }

    // MARK: - Methods

    func fetchSubjects() {
        if let subjects = subjectManager.fetchSubjects() {
            subjectsNames = subjects.map { $0.unwrappedName }
        }
    }

    func addSubject(name: String) {
        subjectManager.createSubject(name: name, color: "FocusSelectionColor")
        fetchSubjects()
        selectedSubjectName = name
    }

    func saveSchedule() {
        if let scheduleID {
            updateSchedule(withID: scheduleID)
        } else {
            createNewSchedule()
        }
    }

    private func createNewSchedule() {
        guard let subject = subjectManager.fetchSubject(withName: selectedSubjectName) else { return }

        if let selectedIndex = days.firstIndex(where: { $0 == selectedDay }) {
            let dayOfTheWeek = Int(selectedIndex)
            
            handleAlerts()
            
            scheduleManager.createSchedule(
                subjectID: subject.unwrappedID,
                dayOfTheWeek: dayOfTheWeek,
                startTime: selectedStartTime,
                endTime: selectedEndTime,
                blocksApps: blocksApps,
                earlyAlarm: alarmBefore,
                imediateAlarm: alarmInTime
            )
        }
    }

    private func handleAlerts() {
        let selectedDate = selectedStartTime
        let title = String(localized: "reminder")
        let bodyBefore = String(format: NSLocalizedString("comingEvent", comment: ""), String(selectedSubjectName))
        let bodyInTime = String(format: NSLocalizedString("immediateEvent", comment: ""), String(selectedSubjectName))

        if alarmBefore {
            notificationService?.scheduleWeeklyNotification(
                title: title,
                body: bodyBefore,
                date: selectedDate,
                minutesBefore: 5,
                scheduleInfo: nil
            )
        }

        if alarmInTime {
            let scheduleInfo = ScheduleInfo(
                subjectName: selectedSubjectName,
                dates: (selectedStartTime, selectedEndTime)
            )

            notificationService?.scheduleWeeklyNotification(
                title: title,
                body: bodyInTime,
                date: selectedDate,
                minutesBefore: 0,
                scheduleInfo: scheduleInfo
            )
        }
    }

    private func updateSchedule(withID id: String) {
        if let schedule = scheduleManager.fetchSchedule(from: id) {
            if let subjects = subjectManager.fetchSubjects() {
                if let subject = subjects.first(where: { $0.unwrappedName == selectedSubjectName }) {
                    schedule.subjectID = subject.unwrappedID

                    if let dayOfTheWeek = days.firstIndex(where: { $0 == selectedDay }),
                       let startTime = schedule.startTime {
                        
                        schedule.dayOfTheWeek = Int16(dayOfTheWeek)
                        notificationService?.cancelNotifications(forDate: startTime)
                    }

                    schedule.startTime = selectedStartTime
                    schedule.endTime = selectedEndTime
                    schedule.blocksApps = blocksApps
                    schedule.earlyAlarm = alarmBefore
                    schedule.imediateAlarm = alarmInTime

                    handleAlerts()
                }
            }

            scheduleManager.updateSchedule(schedule)
        }
    }

    func isNewScheduleAvailable() -> Bool {
        var isAvailable = true

        var allSchedules = [Schedule]()

        if let subjects = subjectManager.fetchSubjects() {
            for subject in subjects {
                if let schedules = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID) {
                    allSchedules.append(contentsOf: schedules)
                }
            }
        }

        var filteredSchedules = allSchedules

        if let selectedIndex = days.firstIndex(where: { $0 == self.selectedDay }) {
            let dayOfWeek = Int(selectedIndex)
            filteredSchedules = filteredSchedules.filter { $0.dayOfTheWeek == dayOfWeek }
        }

        if !filteredSchedules.isEmpty {
            isAvailable = isTimeSlotAvailable(existingSchedules: filteredSchedules)
        }

        return isAvailable
    }

    private func isTimeSlotAvailable(existingSchedules: [Schedule]) -> Bool {
        guard let newStartTime = formatDate(selectedStartTime),
              let newEndTime = formatDate(selectedEndTime) else { return false }

        for schedule in existingSchedules {

            if let existingStartTime = formatDate(schedule.unwrappedStartTime),
               let existingEndTime = formatDate(schedule.unwrappedEndTime),
               newStartTime < existingEndTime && newEndTime > existingStartTime,
               schedule.unwrappedID != scheduleID {
                
                return false
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
        guard let firstDateHour = getHourFrom(date: date),
              let firstDateMinute = getMinuteFrom(date: date) else { return nil }

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
        let subject = subjectManager.fetchSubject(withID: schedule?.subjectID)

        if let _ = subject {
            return String(localized: "editActivity")
        } else {
            return String(localized: "newActivity")
        }
    }

    func removeSchedule() {
        guard let schedule else { return }

        scheduleManager.deleteSchedule(schedule)
    }

    func cancelNotifications() {
        guard let schedule else { return }

        notificationService?.cancelNotifications(forDate: schedule.unwrappedStartTime)
    }

    func requestNotificationsAuthorization() {
        notificationService?.requestAuthorization { granted, error in
            if granted {
                print("notification persimission granted")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getColorBySubjectName(name: String) -> String {
        let subject = subjectManager.fetchSubject(withName: name)
        let subjectColor = subject?.unwrappedColor ?? "redPicker"
        return subjectColor
    }
}
