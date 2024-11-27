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

    // MARK: - Schedule Properties

    let days = [
        String(localized: "sunday"),
        String(localized: "monday"),
        String(localized: "tuesday"),
        String(localized: "wednesday"),
        String(localized: "thursday"),
        String(localized: "friday"),
        String(localized: "saturday"),
    ]
    var editingScheduleDay: String
    
    struct SelectedDay {
        var name: String
        var startTime: Date
        var endTime: Date
    }
    
    var selectedDays: [SelectedDay]

    var editingScheduleStartTime: Date
    var editingScheduleEndTime: Date
    
    var alarmNames: [String] = [
        String(localized: "noneAlarm"),
        String(format: NSLocalizedString("timeBefore", comment: ""), "1h"),
        String(format: NSLocalizedString("timeBefore", comment: ""), "30 min"),
        String(format: NSLocalizedString("timeBefore", comment: ""), "15 min"),
        String(format: NSLocalizedString("timeBefore", comment: ""), "5 min"),
        String(localized: "onTime"),
    ]
    var selectedAlarms: [Int]

    var blocksApps: Bool
    
    // MARK: - Subject Properties
    
    var subjectsNames: [String]
    var selectedSubjectName: String

    private var scheduleID: String?
    var schedule: Schedule?
    
    let subjectColors = [
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
    
    lazy var selectedSubjectColor: Box<String> = Box(subjectColors[0])

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
        selectedAlarms = [0]

        if let subjects = self.subjectManager.fetchSubjects() {
            subjectsNames = subjects.map { $0.unwrappedName }
            if !subjectsNames.isEmpty {
                selectedSubjectName = subjectsNames[0]
            }
        }

        if let schedule {
            if let subject = self.subjectManager.fetchSubject(withID: schedule.unwrappedSubjectID) {
                selectedSubjectName = subject.unwrappedName
            }

            selectedStartTime = schedule.unwrappedStartTime
            selectedEndTime = schedule.unwrappedEndTime
            selectedDayIndex = schedule.unwrappedDay
            selectedAlarms = schedule.unwrappedAlarms
        }

        editingScheduleDay = days[selectedDayIndex]
        
        let selectedDay = SelectedDay(
            name: days[selectedDayIndex],
            startTime: selectedStartTime,
            endTime: selectedEndTime
        )
        selectedDays = [selectedDay]
        
        self.selectedSubjectName = selectedSubjectName
        self.editingScheduleStartTime = selectedStartTime
        self.editingScheduleEndTime = selectedEndTime
        scheduleID = schedule?.unwrappedID
        blocksApps = schedule?.blocksApps ?? false
        
        selectedSubjectColor = Box(selectAvailableColor())
    }
}

// MARK: - Handling Schedules

extension ScheduleDetailsViewModel {
    func saveSchedule() {
        if isUpdatingSchedule() {
            updateSchedule(withID: scheduleID ?? String())
        } else {
            createNewSchedules()
        }
    }
    
    func isUpdatingSchedule() -> Bool {
        if scheduleID == nil {
            return false
        } else {
            return true
        }
    }

    private func createNewSchedules() {
        for selectedDay in selectedDays {
            handleAlarm(startTime: selectedDay.startTime, endTime: selectedDay.endTime)
            createNewSchedule(withDay: selectedDay)
        }
    }
    
    private func createNewSchedule(withDay selectedDay: SelectedDay) {
        guard let subject = subjectManager.fetchSubject(withName: selectedSubjectName),
              let selectedIndex = days.firstIndex(where: { $0 == selectedDay.name }) else {
            
            return
        }
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: Int(selectedIndex),
            startTime: selectedDay.startTime,
            endTime: selectedDay.endTime,
            blocksApps: blocksApps,
            alarms: selectedAlarms
        )
    }
    
    private func updateSchedule(withID id: String) {
        guard let schedule = scheduleManager.fetchSchedule(from: id),
              let subjects = subjectManager.fetchSubjects(),
              let subject = subjects.first(where: { $0.unwrappedName == selectedSubjectName }) else {
            
            return
        }
        
        schedule.subjectID = subject.unwrappedID
        
        if let dayOfTheWeek = days.firstIndex(where: { $0 == editingScheduleDay }) {
            schedule.dayOfTheWeek = Int16(dayOfTheWeek)
            cancelNotifications()
        }
        
        if editingScheduleStartTime > schedule.unwrappedStartTime {
            schedule.completed = false
        }
        
        schedule.startTime = editingScheduleStartTime
        schedule.endTime = editingScheduleEndTime
        schedule.blocksApps = blocksApps
        let scheduleAlarms = selectedAlarms.reduce(0) { $0 * 10 + $1 }
        schedule.alarms = Int16(scheduleAlarms)

        handleAlarm(startTime: editingScheduleStartTime, endTime: editingScheduleEndTime)
        
        scheduleManager.updateSchedule(schedule)
    }

    func isNewScheduleAvailable() -> Bool {
        guard let subjects = subjectManager.fetchSubjects() else { return false }
        
        var isAvailable = true
        var allSchedules = [Schedule]()
        
        subjects.forEach { subject in
            if let schedules = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID) {
                allSchedules.append(contentsOf: schedules)
            }
        }

        let filteredSchedules = getFilteredSchedules(from: allSchedules)
        
        if !filteredSchedules.isEmpty {
            isAvailable = isTimeSlotAvailable(existingSchedules: filteredSchedules)
        }

        return isAvailable
    }
    
    private func getFilteredSchedules(from schedules: [Schedule]) -> [Schedule] {
        let isUpdating = isUpdatingSchedule()
        var filteredSchedules: [Schedule] = []
        
        if isUpdating {
            if let selectedIndex = days.firstIndex(where: { $0 == editingScheduleDay }) {
                
                let dayOfWeek = Int(selectedIndex)
                filteredSchedules = schedules.filter { $0.dayOfTheWeek == dayOfWeek }
            }
        } else {
            for selectedDay in selectedDays {
                if let selectedIndex = days.firstIndex(where: { $0 == selectedDay.name }) {
                    
                    let dayOfWeek = Int(selectedIndex)
                    let currentFilteredSchedules = schedules.filter { $0.dayOfTheWeek == dayOfWeek }
                    filteredSchedules.append(contentsOf: currentFilteredSchedules)
                }
            }
        }
        
        return filteredSchedules
    }

    private func isTimeSlotAvailable(existingSchedules: [Schedule]) -> Bool {
        let isUpdating = isUpdatingSchedule()
        
        if isUpdating {
            guard let newStartTime = formatDate(editingScheduleStartTime),
                  let newEndTime = formatDate(editingScheduleEndTime) else { return false }
            
            return compareStartAndEndTime(ofSchedules: existingSchedules, newStartTime: newStartTime, newEndTime: newEndTime)
        } else {
            for selectedDay in selectedDays {
                guard let newStartTime = formatDate(selectedDay.startTime),
                      let newEndTime = formatDate(selectedDay.endTime) else { return false }
                
                let comparison = compareStartAndEndTime(ofSchedules: existingSchedules, newStartTime: newStartTime, newEndTime: newEndTime)
                
                if !comparison {
                    return false
                }
            }
            
            return true
        }
    }
    
    private func compareStartAndEndTime(ofSchedules existingSchedules: [Schedule], newStartTime: Date, newEndTime: Date) -> Bool {
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
    
    func removeSchedule() {
        guard let schedule else { return }

        scheduleManager.deleteSchedule(schedule)
    }
    
    func getSelectedDayView(dayViews: [DayView], weekdays: [Int]) -> DayView? {
        var selectedDayView: DayView?
        
        if isUpdatingSchedule() {
            if let selectedWeekdayIndex = days.firstIndex(where: { $0 == editingScheduleDay }),
               let index = weekdays.firstIndex(where: { $0 == Int(selectedWeekdayIndex) }) {
                
                selectedDayView = dayViews[index]
            }
        } else {
            if let selectedDay = selectedDays.first,
               let selectedWeekdayIndex = days.firstIndex(where: { $0 == selectedDay.name }),
               let index = weekdays.firstIndex(where: { $0 == Int(selectedWeekdayIndex) }) {
                
                selectedDayView = dayViews[index]
            }
        }
        
        return selectedDayView
    }
}

// MARK: - TableView Sections

extension ScheduleDetailsViewModel {
    func numberOfSections() -> Int {
        2 + numberOfDaySections() + numberOfAlarmSections()
    }
}

// MARK: - Day Sections

extension ScheduleDetailsViewModel {
    func numberOfDaySections() -> Int {
        let isUpdating = isUpdatingSchedule()
        
        if isUpdating {
            return 1
        } else {
            return selectedDays.count
        }
    }
    
    private func getUpdatedDaysInfo() -> (remainingDays: [String], lastDayIndex: Int) {
        var remainingDays = days
        var lastDayIndex = Int()
        
        for selectedDay in selectedDays {
            if let index = remainingDays.firstIndex(where: { $0 == selectedDay.name }) {
                remainingDays.remove(at: index)
                lastDayIndex = index
            }
        }
        
        return (remainingDays, lastDayIndex)
    }
    
    func createNewDaySection() {
        let updatedInfo = getUpdatedDaysInfo()
        let remainingDays = updatedInfo.remainingDays
        
        if !remainingDays.isEmpty {
            let dayIndex = updatedInfo.lastDayIndex % remainingDays.count
            let day = remainingDays[dayIndex]
            let currentDate = Date.now
            let startTime = currentDate
            let endTime = startTime.addingTimeInterval(60)
            
            let newDay = ScheduleDetailsViewModel.SelectedDay(
                name: day,
                startTime: startTime,
                endTime: endTime
            )
            
            selectedDays.append(newDay)
        }
    }
    
    func deleteLastDaySection() {
        selectedDays.removeLast()
    }
    
    func filteredDayNames(for dayIndex: Int) -> [String] {
        if selectedDays.count == 1 {
            return days
        } else {
            var filteredDays = days
            
            for (index, selectedDay) in selectedDays.enumerated() where index != dayIndex {
                if let removedIndex = filteredDays.firstIndex(where: { $0 == selectedDay.name }) {
                    filteredDays.remove(at: removedIndex)
                }
            }

            return filteredDays
        }
    }
    
    func getSelectedDayIndex(forSection section: Int) -> Int? {
        let isUpdating = isUpdatingSchedule()
        var items: [String] = []
        var selectedItem: String = String()
        
        if isUpdating {
            items = days
            selectedItem = editingScheduleDay
        } else {
            let index = section - 1
            items = filteredDayNames(for: index)
            selectedItem = selectedDays[index].name
        }
        
        guard let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) else {
            return nil
        }
        
        return Int(selectedIndex)
    }
    
    func getSelectedDate(forSection section: Int) -> (startTime: Date, endTime: Date)? {
        let isUpdating = isUpdatingSchedule()
        
        if isUpdating {
            return (editingScheduleStartTime, editingScheduleEndTime)
        }
        
        let index = section - 1
        let startTime = selectedDays[index].startTime
        let endTime = selectedDays[index].endTime
        
        return (startTime, endTime)
    }
    
    func getDayOfWeekText(forSection section: Int) -> String {
        let isUpdating = isUpdatingSchedule()
        
        if isUpdating {
            return editingScheduleDay
        }
        
        let index = section - 1
        return selectedDays[index].name
    }
    
    func getDatePickerTag(forRowAt indexPath: IndexPath) -> Int {
        let isUpdating = isUpdatingSchedule()
        let section = indexPath.section
        
        if isUpdating {
            return 1
        }
        
        let index = section - 1
        return index * 2 + 1
    }
}

// MARK: - Alarm Sections

extension ScheduleDetailsViewModel {
    func numberOfAlarmSections() -> Int {
        selectedAlarms.count
    }
    
    func getAlarmText(forIndex index: Int) -> String {
        let selectedAlarm = selectedAlarms[index]
        return alarmNames[selectedAlarm]
    }
    
    func filteredAlarmNames(for alarmIndex: Int) -> [String] {
        if selectedAlarms.count == 1 {
            return alarmNames
        } else {
            var filteredAlarmNames = alarmNames
            
            if let noneIndex = filteredAlarmNames.firstIndex(where: { $0 == alarmNames[0] }) {
                filteredAlarmNames.remove(at: noneIndex)
            }
            
            let selectedAlarmNames = selectedAlarms.map { alarmNames[$0] }
            
            for (index, selectedAlarmName) in selectedAlarmNames.enumerated() where index != alarmIndex {
                if let removedIndex = filteredAlarmNames.firstIndex(where: { $0 == selectedAlarmName }) {
                    filteredAlarmNames.remove(at: removedIndex)
                }
            }
            
            return filteredAlarmNames
        }
    }
    
    func getSelectedAlarmIndex(forSection section: Int) -> Int? {
        let numberOfDaySections = numberOfDaySections()
        let index = section - 1 - numberOfDaySections
        let items = filteredAlarmNames(for: index)
        let selectedAlarm = selectedAlarms[index]
        let selectedItem = alarmNames[selectedAlarm]
        
        guard let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) else {
            return nil
        }
        
        return Int(selectedIndex)
    }
    
    private func getUpdatedAlarmsInfo() -> (remainingAlarmNames: [String], lastAlarmIndex: Int) {
        var remainingAlarmNames = alarmNames
        let numberOfAlarmSections = numberOfAlarmSections()
        
        if numberOfAlarmSections > 1 {
            if let noneIndex = remainingAlarmNames.firstIndex(where: { $0 == alarmNames[0] }) {
                remainingAlarmNames.remove(at: noneIndex)
            }
        }
        
        var lastAlarmIndex = Int()
        let selectedAlarmNames = selectedAlarms.map { alarmNames[$0] }
        
        for selectedAlarmName in selectedAlarmNames {
            if let index = remainingAlarmNames.firstIndex(where: { $0 == selectedAlarmName }) {
                remainingAlarmNames.remove(at: index)
                lastAlarmIndex = index
            }
        }
        
        return (remainingAlarmNames, lastAlarmIndex)
    }
    
    func createNewAlarmSection() {
        let updatedInfo = getUpdatedAlarmsInfo()
        let remainingAlarmNames = updatedInfo.remainingAlarmNames
        
        if !remainingAlarmNames.isEmpty {
            let alarmIndex = updatedInfo.lastAlarmIndex % remainingAlarmNames.count
            let newAlarmName = remainingAlarmNames[alarmIndex]
            
            if let index = alarmNames.firstIndex(where: { $0 == newAlarmName }) {
                selectedAlarms.append(Int(index))
            }
        }
    }
}

// MARK: - Handling Subjects

extension ScheduleDetailsViewModel {
    func setSubjectNames() {
        if let subjects = subjectManager.fetchSubjects() {
            subjectsNames = subjects.map { $0.unwrappedName }
        }
    }
    
    func getSubjectName() -> String {
        if selectedSubjectName.isEmpty {
            String(localized: "createNewSubject")
        } else {
            selectedSubjectName
        }
    }

    func addSubject(name: String) {
        subjectManager.createSubject(name: name, color: "FocusSelectionColor")
        setSubjectNames()
        selectedSubjectName = name
    }
    
    func getColorBySubjectName(name: String) -> String {
        let subject = subjectManager.fetchSubject(withName: name)
        let subjectColor = subject?.unwrappedColor ?? "bluePicker"
        return subjectColor
    }
    
    func selectAvailableColor() -> String {
        let existingSubjects = subjectManager.fetchSubjects() ?? []
        let usedColors = Set(existingSubjects.map { $0.unwrappedColor })

        for color in subjectColors where !usedColors.contains(color) {
            return color
        }

        return subjectColors.first ?? "bluePicker"
    }
    
    func createSubject(name: String) {
        subjectManager.createSubject(name: name, color: selectedSubjectColor.value)
    }
    
    func getSubjects() -> [Subject]? {
        subjectManager.fetchSubjects()
    }
    
    func deleteLastAlarmSection() {
        selectedAlarms.removeLast()
    }
}

// MARK: - Notifications Handling

extension ScheduleDetailsViewModel {
    func requestNotificationsAuthorization() {
        notificationService?.requestAuthorization { granted, error in
            if granted {
                print("notification persimission granted")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelNotifications() {
        guard let schedule else { return }

        notificationService?.cancelNotifications(forDate: schedule.unwrappedStartTime)
    }
}

// MARK: - Alarms

extension ScheduleDetailsViewModel {
    private func handleAlarm(startTime: Date, endTime: Date) {
        let title = String(localized: "reminder")
        
        let scheduleInfo = ScheduleInfo(
            subjectName: selectedSubjectName,
            dates: (startTime, endTime)
        )
        
        for selectedAlarm in selectedAlarms {
            notificationService?.scheduleWeeklyNotification(
                title: title,
                alarm: selectedAlarm,
                scheduleInfo: scheduleInfo
            )
        }
    }
}

// MARK: - Settings Navigation Items

extension ScheduleDetailsViewModel {
    func getTitleName() -> String {
        let subject = subjectManager.fetchSubject(withID: schedule?.subjectID)

        if let _ = subject {
            return String(localized: "editActivity")
        } else {
            return String(localized: "newActivity")
        }
    }
}

// MARK: - Date Formatting

extension ScheduleDetailsViewModel {
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
    
    func updateDate(withHour hour: Int, minute: Int, currentDate: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components) ?? currentDate
    }

    func getTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
