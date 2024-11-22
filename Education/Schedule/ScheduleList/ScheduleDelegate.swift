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
    // MARK: - Navigation Bar
    
    func plusButtonTapped()
    
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

    func playButtonTapped(_ sender: ActivityButton)

    // MARK: - Schedule Cell

    func getConfiguredScheduleCell(from object: AnyObject, at indexPath: IndexPath, isDaily: Bool) -> AnyObject
    func getNumberOfItemsIn(_ index: Int) -> Int
    func didSelectWeeklySchedule(column: Int, row: Int)
    func didTapDeleteButton(at index: Int)
    func didCancelDeletion()
    func didDeleteSchedule()
}

extension ScheduleViewController: ScheduleDelegate {
    // MARK: - Navigation Bar
    
    func plusButtonTapped() {
        let isShowingButtons = scheduleView.createAcitivityButton.alpha == 1
        
        if isShowingButtons {
            dismissButtons()
        } else {
            setGestureRecognizer()
            
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                
                self.scheduleView.createAcitivityButton.alpha = 1
                self.scheduleView.startActivityButton.alpha = 1
            }
        }
    }
    
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

        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, isSelected: true, isToday: dayOfWeek.isToday)
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
            let isToday = viewModel.isToday(date)
            dayView.dayOfWeek = DayOfWeek(day: dayString, isSelected: isToday, isToday: isToday)

            dayView.tag = index
            dayView.delegate = self

            stack.addArrangedSubview(dayView)
        }
    }

    // MARK: - Floating buttons

    func createActivityButtonTapped() {
        dismissButtons()

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

    func playButtonTapped(_ sender: ActivityButton) {
        guard let focusConfig = sender.focusConfig,
              let indexPath = focusConfig.indexPath else { return }
        
        let isDaily = focusConfig.isDaily

        let schedule = isDaily ? viewModel.schedules[indexPath.section] : viewModel.schedules[indexPath.row]
        let subject = viewModel.getSubject(fromSchedule: schedule)

        let newFocusSessionModel = FocusSessionModel(
            scheduleID: schedule.unwrappedID,
            subject: subject,
            blocksApps: schedule.blocksApps,
            isAlarmOn: schedule.isAlarmOn(),
            color: focusConfig.color
        )

        coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }

    // MARK: - Schedule Cell

    func getConfiguredScheduleCell(from object: AnyObject, at indexPath: IndexPath, isDaily: Bool) -> AnyObject {
        guard let cell = object as? ScheduleCellProtocol else {
            fatalError("Could not get schedule cell for configuration")
        }
        
        cell.delegate = self

        let schedule = isDaily ? viewModel.schedules[indexPath.section] : viewModel.tasks[indexPath.section][indexPath.row]
        let subject = viewModel.getSubject(fromSchedule: schedule)
        let color = UIColor(named: subject?.unwrappedColor ?? "sealBackgroundColor")
        let timeLabelString = getTimeLabelString(for: indexPath, isDaily: isDaily)
        let eventCase = viewModel.getEventCase(for: schedule)

        let cellConfig = CellConfig(
            subject: subject,
            indexPath: indexPath,
            isDaily: isDaily,
            attributedText: timeLabelString,
            eventCase: eventCase,
            color: color
        )
        
        cell.configure(with: cellConfig, traitCollection: self.traitCollection)

        return cell
    }
    
    private func getTimeLabelString(for indexPath: IndexPath, isDaily: Bool) -> NSAttributedString {
        let schedule = isDaily ? viewModel.schedules[indexPath.section] : viewModel.tasks[indexPath.section][indexPath.row]
        let subject = viewModel.getSubject(fromSchedule: schedule)
        let colorName = subject?.unwrappedColor

        let color = UIColor(named: colorName ?? "sealBackgroundColor")
        let font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)
        let startTimeColor: UIColor = (traitCollection.userInterfaceStyle == .light ? color?.darker(by: 0.8) : color) ?? .label
        let endTimeColor: UIColor = (traitCollection.userInterfaceStyle == .light ? color : color?.darker(by: 0.8)) ?? .label

        let attributedString = NSMutableAttributedString()
        let startTimeString = NSAttributedString(string: viewModel.getShortTimeString(for: schedule, isStartTime: true), attributes: [.font: font, .foregroundColor: startTimeColor])
        let endTimeString = NSAttributedString(string: viewModel.getShortTimeString(for: schedule, isStartTime: false), attributes: [.font: font, .foregroundColor: endTimeColor])

        attributedString.append(startTimeString)
        
        if isDaily {
            attributedString.append(NSAttributedString(string: " - ", attributes: [.font: font, .foregroundColor: endTimeColor]))
        } else {
            attributedString.append(NSAttributedString(string: "\n", attributes: [.font: font, .foregroundColor: endTimeColor]))
        }
        
        attributedString.append(endTimeString)

        return attributedString
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
    
    func didTapDeleteButton(at index: Int) {
        viewModel.scheduleToBeDeletedIndex = index
        
        guard let subject = viewModel.getSubject(fromSchedule: viewModel.schedules[index]) else { return }
        
        let alertCase: AlertCase = .deletingSchedule(subject: subject)
        let alertConfig = getAlertConfig(with: alertCase)
        scheduleView.deletionAlertView.config = alertConfig
        scheduleView.deletionAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        scheduleView.deletionAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        scheduleView.changeAlertVisibility(isShowing: true)
    }
    
    private func getAlertConfig(with alertCase: AlertCase) -> AlertView.AlertConfig {
        AlertView.AlertConfig(
            title: alertCase.title,
            body: alertCase.body,
            primaryButtonTitle: alertCase.primaryButtonTitle,
            secondaryButtonTitle: alertCase.secondaryButtonTitle,
            superView: scheduleView,
            position: alertCase.position
        )
    }
    
    func didCancelDeletion() {
        scheduleView.changeAlertVisibility(isShowing: false)
    }
    
    func didDeleteSchedule() {
        scheduleView.changeAlertVisibility(isShowing: false)
        viewModel.removeSchedule()
        loadSchedules()
    }
}
