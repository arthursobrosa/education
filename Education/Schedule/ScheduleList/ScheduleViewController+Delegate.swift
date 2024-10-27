//
//  ScheduleViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - Schedule

@objc 
protocol ScheduleDelegate: AnyObject {
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
    func didSelectWeeklySchedule(column: Int, row: Int)
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
            
            let newDayView = dayViews.first { element in
                guard let newDay = element.dayOfWeek?.day,
                      let lastDay = dayView.dayOfWeek?.day,
                      newDay == lastDay else { return false }
                
                return true
            }

            dayTapped(newDayView ?? dayView)

            return
        }

        // Unable reloading the rows of a table that is already loaded
        let lastDayView = dayViews.first { element in
            guard let isSelected = element.dayOfWeek?.isSelected,
                  isSelected else { return false }
            return true
        }
        guard dayView != lastDayView else { return }

        // Logics to select the day tapped
        unselectDays()

        guard let dayOfWeek = dayView.dayOfWeek else { return }

        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
        viewModel.selectedDate = viewModel.daysOfWeek[dayView.tag]

        loadSchedules()
    }

    func setDaysStack(_ stack: UIStackView) {
        for subview in stack.arrangedSubviews {
            subview.removeFromSuperview()
        }

        viewModel.updateDaysOfWeek()

        let dates = viewModel.daysOfWeek

        for (index, date) in dates.enumerated() {
            let dayView = DayView()

            let dayString = viewModel.dayAbbreviation(date)
            let dateString = viewModel.dayFormatted(date)
            let isToday = viewModel.isToday(date)
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
        dismissButtons()
        coordinator?.showFocusImediate()
    }

    func emptyViewButtonTapped() {
        let viewModel = StudyTimeViewModel()
        coordinator?.showSubjectCreation(viewModel: viewModel)
    }

    // MARK: - Play Button

    func playButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?) {
        guard let indexPath else { return }

        let row = indexPath.row

        let schedule = viewModel.schedules[row]
        let subject = viewModel.getSubject(fromSchedule: schedule)

        let newFocusSessionModel = FocusSessionModel(scheduleID: schedule.unwrappedID, subject: subject, blocksApps: schedule.blocksApps, isAlarmOn: schedule.imediateAlarm, color: color)

        coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }

    // MARK: - Schedule Cell

    func getConfiguredScheduleCell(from cell: ScheduleCell, at indexPath: IndexPath, isDaily: Bool = true) -> UICollectionViewCell {
        cell.delegate = self

        let schedule = isDaily ? viewModel.schedules[indexPath.row] : viewModel.tasks[indexPath.section][indexPath.row]
        let subject = viewModel.getSubject(fromSchedule: schedule)
        let color = UIColor(named: subject?.unwrappedColor ?? "sealBackgroundColor")
        let timeLabelString = getTimeLabelString(for: indexPath, isDaily: isDaily)
        let eventCase = viewModel.getEventCase(for: schedule)

        let cellConfig = ScheduleCell.CellConfig(
            subject: subject,
            indexPath: indexPath,
            isDaily: isDaily,
            attributedText: timeLabelString,
            eventCase: eventCase,
            color: color
        )

        cell.config = cellConfig

        return cell
    }

    func getNumberOfItemsIn(_ index: Int) -> Int {
        return viewModel.tasks[index].count
    }

    func didSelectWeeklySchedule(column: Int, row: Int) {
        if !viewModel.tasks[column].isEmpty {
            let task = viewModel.tasks[column][row]

            coordinator?.showScheduleDetailsModal(schedule: task)
        }
    }
}
