//
//  ScheduleViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - Schedule
protocol ScheduleDelegate: AnyObject {
    func setPicker(_ picker: UIStackView)
    func createAcitivityTapped()
    func startAcitivityTapped()
}

extension ScheduleViewController: ScheduleDelegate {
    func setPicker(_ picker: UIStackView) {
        let dates = self.viewModel.daysOfWeek
        
        for (index, date) in dates.enumerated() {
            let dayView = DayView()
            
            let dayString = self.viewModel.dayAbbreviation(date)
            let dateString = self.viewModel.dayFormatted(date)
            let isSelected = self.viewModel.selectedDay == Calendar.current.component(.weekday, from: date) - 1
            let isToday = self.viewModel.selectedDay == Calendar.current.component(.weekday, from: date) - 1
            dayView.dayOfWeek = DayOfWeek(day: dayString, date: dateString, isSelected: isSelected, isToday: isToday)
            
            dayView.tag = index
            dayView.delegate = self
            
            picker.addArrangedSubview(dayView)
        }
    }
    
    func createAcitivityTapped() {
        self.dismissButtons()
        self.coordinator?.showScheduleDetails(schedule: nil, selectedDay: self.viewModel.selectedDay)
    }
    
    func startAcitivityTapped() {
        self.dismissButtons()
        self.coordinator?.showFocusImediate()
    }
}

// MARK: - Day
protocol DayDelegate: AnyObject {
    func dayTapped(_ dayView: DayView)
}

extension ScheduleViewController: DayDelegate {
    func dayTapped(_ dayView: DayView) {
        self.unselectDays()
        
        guard let dayOfWeek = dayView.dayOfWeek else { return }
        
        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
        self.viewModel.selectedDay = dayView.tag
        
        if(self.scheduleView.viewModeSelector.selectedSegmentIndex == 1){
            didSelectDailyMode()
            self.scheduleView.viewModeSelector.selectedSegmentIndex = 0
        }
        
        
        self.loadSchedules()
    }
}

// MARK: - Play Button
protocol ScheduleButtonDelegate: AnyObject {
    func activityButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?)
}

extension ScheduleViewController: ScheduleButtonDelegate {
    func activityButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?) {
        guard let indexPath else { return }
        
        let row = indexPath.row
        
        let schedule = self.viewModel.schedules[row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        
        let newFocusSessionModel = FocusSessionModel(isPaused: false, subject: subject, blocksApps: schedule.blocksApps, isAlarmOn: schedule.imediateAlarm, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
}

protocol ViewModeSelectorDelegate: AnyObject {
    func didSelectDailyModeToday()
    func didSelectWeeklyMode()
}

extension ScheduleViewController: ViewModeSelectorDelegate {
    func didSelectDailyMode() {
        self.scheduleView.tableView.isHidden = false
        self.scheduleView.collectionViews.isHidden = true
    }
    
    func didSelectDailyModeToday() {
        self.unselectDays()
        self.selectToday()
        self.scheduleView.tableView.isHidden = false
        self.scheduleView.collectionViews.isHidden = true
        self.loadSchedules()
        self.scheduleView.tableView.reloadData()
    }
    
    func didSelectWeeklyMode() {
        self.unselectDays()
        self.scheduleView.tableView.isHidden = true
        self.scheduleView.collectionViews.isHidden = false
    }
    
    func firstThreeLetters(of text: String) -> String {
        return String(text.prefix(3))
    }
}
