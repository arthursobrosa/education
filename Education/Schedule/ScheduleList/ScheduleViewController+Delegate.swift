//
//  ScheduleViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - Schedule
protocol ScheduleDelegate: AnyObject {
    // MARK: - View Mode
    func setSegmentedControl(_ segmentedControl: UISegmentedControl)
    
    // MARK: - Day
    func setPicker(_ picker: UIStackView)
    func dayTapped(_ dayView: DayView)
    
    // MARK: - Floating buttons
    func createAcitivityTapped()
    func startAcitivityTapped()
    func emptyViewButtonTapped()
    
    // MARK: - Play button
    func playButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?)
}

extension ScheduleViewController: ScheduleDelegate {
    // MARK: - View Mode
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let viewModes = self.viewModel.viewModes.map { $0.name }
        let selectedViewMode = self.viewModel.selectedViewMode.name
        
        for (index, viewMode) in viewModes.enumerated() {
            let action = UIAction(title: viewMode) { _ in
                self.viewModel.selectedViewMode = self.viewModel.viewModes[index]
                
                switch index {
                    case 0:
                        self.selectToday()
                    case 1:
                        self.unselectDays()
                    default:
                        break
                }
                
                self.loadSchedules()
            }
            
            segmentedControl.insertSegment(action: action, at: index, animated: false)
            
            if viewMode == selectedViewMode {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    // MARK: Day
    func dayTapped(_ dayView: DayView) {
        if self.scheduleView.viewModeSelector.selectedSegmentIndex == 1 {
            self.scheduleView.viewModeSelector.selectedSegmentIndex = 0
            self.viewModel.selectedViewMode = .daily
            self.dayTapped(dayView)
            
            return
        }
        
        self.unselectDays()
        
        guard let dayOfWeek = dayView.dayOfWeek else { return }
        
        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
        self.viewModel.selectedDay = dayView.tag
        
        self.loadSchedules()
    }
    
    func setPicker(_ picker: UIStackView) {
        picker.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        var dates = self.viewModel.daysOfWeek
        
//        let sortedDates = Array(dates[UserDefaults.dayOfWeek...]) + Array(dates[..<UserDefaults.dayOfWeek])
        
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
    
    // MARK: - Floating buttons
    func createAcitivityTapped() {
        self.dismissButtons()
        
        guard self.viewModel.isThereAnySubject() else {
            self.showNoSubjectAlert()
            
            return
        }
        
        let selectedDay = self.viewModel.selectedViewMode == .daily ? self.viewModel.selectedDay : Calendar.current.component(.weekday, from: Date()) - 1
        
        self.coordinator?.showScheduleDetails(schedule: nil, selectedDay: selectedDay)
    }
    
    func startAcitivityTapped() {
        self.dismissButtons()
        self.coordinator?.showFocusImediate()
    }
    
    func emptyViewButtonTapped() {
        let vm = StudyTimeViewModel()
        self.coordinator?.showSubjectCreation(viewModel: vm)
    }
    
    // MARK: - Play Button
    func playButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?) {
        guard let indexPath else { return }
        
        let row = indexPath.row
        
        let schedule = self.viewModel.schedules[row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        
        let newFocusSessionModel = FocusSessionModel(subject: subject, blocksApps: schedule.blocksApps, isAlarmOn: schedule.imediateAlarm, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
}
