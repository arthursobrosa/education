//
//  ScheduleViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - Schedule
@objc protocol ScheduleDelegate: AnyObject {
    // MARK: - View Mode
    func setSegmentedControl(_ segmentedControl: UISegmentedControl)
    
    // MARK: - Day
    func setDaysStack(_ picker: UIStackView)
    func dayTapped(_ dayView: DayView)
    
    // MARK: - Floating buttons
    func createActivityButtonTapped()
    func startActivityButtonTapped()
    func emptyViewButtonTapped()
    
    // MARK: - Play button
    func playButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?)
    
    // MARK: - Schedule Cell
    func getConfiguredScheduleCell(from cell: ScheduleCell, at indexPath: IndexPath, isDaily: Bool) -> UICollectionViewCell
    func getNumberOfItemsIn(_ index: Int) -> Int
    func didSelectWeeklySchedule(at indexPath: IndexPath)
}

extension ScheduleViewController: ScheduleDelegate {
    // MARK: - View Mode
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let scheduleModes = viewModel.scheduleModes.map { $0.name }
        let selectedScheduleMode = viewModel.selectedScheduleMode.name
        
        for (index, scheduleMode) in scheduleModes.enumerated() {
            let action = UIAction(title: scheduleMode) { [weak self] _ in
                guard let self else { return }
                
                self.viewModel.selectedScheduleMode = self.viewModel.scheduleModes[index]
                
                switch index {
                    case 0:
                        self.selectToday()
                    case 1:
                        self.selectToday()
                        self.unselectDays()
                    default:
                        break
                }
                
                self.loadSchedules()
            }
            
            segmentedControl.insertSegment(action: action, at: index, animated: false)
            
            if scheduleMode == selectedScheduleMode {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
    
    // MARK: Day
    func dayTapped(_ dayView: DayView) {
        let dayViews = scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }
        
        // Day is tapped when weekly view mode is currently on
        if scheduleView.scheduleModeSelector.selectedSegmentIndex == 1 {
            scheduleView.scheduleModeSelector.selectedSegmentIndex = 0
            viewModel.selectedScheduleMode = .daily
            
            let newDayView = dayViews.first { $0.dayOfWeek!.day == dayView.dayOfWeek!.day }
            
            dayTapped(newDayView ?? dayView)
            
            return
        }
        
        // Unable reloading the rows of a table that is already loaded
        let lastDayView = dayViews.first { $0.dayOfWeek!.isSelected }
        guard dayView != lastDayView else { return }
        
        // Logics to select the day tapped
        unselectDays()
        
        guard let dayOfWeek = dayView.dayOfWeek else { return }
        
        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
        viewModel.selectedDate = viewModel.daysOfWeek[dayView.tag]
        
        loadSchedules()
    }
    
    func setDaysStack(_ stack: UIStackView) {
        stack.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        self.viewModel.updateDaysOfWeek()
        
        let dates = self.viewModel.daysOfWeek
        
        for (index, date) in dates.enumerated() {
            let dayView = DayView()
            
            let dayString = self.viewModel.dayAbbreviation(date)
            let dateString = self.viewModel.dayFormatted(date)
            let isToday = self.viewModel.isToday(date)
            dayView.dayOfWeek = DayOfWeek(day: dayString, date: dateString, isSelected: isToday, isToday: isToday)
            
            dayView.tag = index
            dayView.delegate = self
            
            stack.addArrangedSubview(dayView)
        }
    }
    
    // MARK: - Floating buttons
    func createActivityButtonTapped() {
        dismissButtons()
        
        guard viewModel.hasSubjects() else {
            showNoSubjectAlert()
            return
        }
        
        let selectedDay = viewModel.selectedScheduleMode == .daily ? viewModel.selectedWeekday : Calendar.current.component(.weekday, from: Date()) - 1
        
        coordinator?.showScheduleDetails(schedule: nil, selectedDay: selectedDay)
    }
    
    func startActivityButtonTapped() {
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
    
    // MARK: - Schedule Cell
    func getConfiguredScheduleCell(from cell: ScheduleCell, at indexPath: IndexPath, isDaily: Bool = true) -> UICollectionViewCell {
        let schedule = isDaily ? self.viewModel.schedules[indexPath.row] : self.viewModel.tasks[indexPath.section][indexPath.row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        let color = subject?.unwrappedColor

        cell.delegate = self

        cell.color = UIColor(named: color ?? "sealBackgroundColor")
        cell.subject = subject

        let timeLabelString = self.getTimeLabelString(for: indexPath, isDaily: isDaily)
        let eventCase = self.viewModel.getEventCase(for: schedule)
        cell.configure(with: timeLabelString, and: eventCase)

        cell.indexPath = indexPath
        
        cell.isDaily = isDaily

        return cell
    }
    
    func getNumberOfItemsIn(_ index: Int) -> Int {
        return self.viewModel.tasks[index].count
    }
    
    func didSelectWeeklySchedule(at indexPath: IndexPath) {
        if !self.viewModel.tasks[indexPath.section].isEmpty {
            let task = viewModel.tasks[indexPath.section][indexPath.item]
            
            self.coordinator?.showScheduleDetailsModal(schedule: task)
        }
    }
}
