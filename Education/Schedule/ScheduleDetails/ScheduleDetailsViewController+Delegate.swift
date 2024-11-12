//
//  ScheduleDetailsViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

@objc
protocol ScheduleDetailsDelegate: AnyObject {
    func cancelButtonTapped()
    func deleteSchedule()
    func saveSchedule()
    func getSubjectColors() -> [String]
    func getSelectedSubjectColor() -> String
    func setSelectedSubjectColor(_ color: String)
    func showColorPopover()
    func dismissColorPopover()
    func dayOfWeekLabelTapped(_ sender: UITapGestureRecognizer)
    func datePickerEditionBegan(_ sender: FakeDatePicker)
    func datePickerEditionEnded(_ sender: FakeDatePicker)
}

extension ScheduleDetailsViewController: ScheduleDetailsDelegate {
    func cancelButtonTapped() {
        coordinator?.dismiss(animated: true)
    }
    
    func deleteSchedule() {
        let alertController = UIAlertController(title: String(localized: "activityDeletionTitle"), message: String(localized: "activityDeletionMessage"), preferredStyle: .alert)

        let yesAction = UIAlertAction(title: String(localized: "yes"), style: .destructive) { [weak self] _ in
            guard let self else { return }

            self.viewModel.cancelNotifications()
            self.viewModel.removeSchedule()

            self.coordinator?.dismiss(animated: true)
        }

        let noAction = UIAlertAction(title: String(localized: "no"), style: .cancel)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true)
    }

    func saveSchedule() {
        if viewModel.selectedSubjectName.isEmpty {
            showNoSubjectAlert()
            return
        }

        if !viewModel.isNewScheduleAvailable() {
            showInvalidDatesAlert()
            return
        }

        viewModel.saveSchedule()
        coordinator?.dismiss(animated: true)
    }
    
    func getSubjectColors() -> [String] {
        viewModel.subjectColors
    }
    
    func getSelectedSubjectColor() -> String {
        viewModel.selectedSubjectColor.value
    }
    
    func setSelectedSubjectColor(_ color: String) {
        viewModel.selectedSubjectColor.value = color
    }
    
    func showColorPopover() {
        if let popover = createColorPopover() {
            popover.modalPresentationStyle = .popover
            present(popover, animated: true)
        }
    }
    
    private func createColorPopover() -> Popover? {
        let tableView = scheduleDetailsView.subjectCreationView.tableView
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let popoverVC = Popover(contentSize: CGSize(width: 190, height: 195))
        let sourceRect = CGRect(x: cell.bounds.maxX - 31,
                                y: cell.bounds.midY + 15,
                                width: 0,
                                height: 0)

        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)

        let paddedView = UIView(frame: CGRect(x: 0, y: 0, width: 190, height: 195))
        paddedView.translatesAutoresizingMaskIntoConstraints = false
        popoverVC.view = paddedView
        
        let collectionView = scheduleDetailsView.subjectCreationView.collectionView

        paddedView.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: paddedView.topAnchor, constant: padding * 2.5),
            collectionView.leadingAnchor.constraint(equalTo: paddedView.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: paddedView.trailingAnchor, constant: -padding),
            collectionView.bottomAnchor.constraint(equalTo: paddedView.bottomAnchor, constant: -padding),
        ])

        return popoverVC
    }
    
    func dismissColorPopover() {
        dismiss(animated: true)
    }
    
    func dayOfWeekLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let dateLabel = sender.view as? UILabel else { return }
        
        let tableView = scheduleDetailsView.tableView
        let indexPath = IndexPath(row: 0, section: dateLabel.tag)
        
        if let popover = createDayPopover(forTableView: tableView, at: indexPath) {
            isPopoverOpen.toggle()
            present(popover, animated: true)
        }
    }
    
    @objc
    func datePickerEditionBegan(_ sender: FakeDatePicker) {
        guard let datePickers = getDatePickers(forDatePickerTag: sender.tag) else { return }
        
        let startDatePicker = datePickers.start
        let endDatePicker = datePickers.end

        endDatePicker.minimumDate = getMinimumDate(forDatePickerTag: sender.tag)

        startDatePicker.isEnabled = !sender.tag.isMultiple(of: 2)
        endDatePicker.isEnabled = sender.tag.isMultiple(of: 2)
    }

    @objc
    func datePickerEditionEnded(_ sender: FakeDatePicker) {
        updateStartAndEndTime(tag: sender.tag, date: sender.date)
        
        guard let datePickers = getDatePickers(forDatePickerTag: sender.tag) else { return }
        
        let startDatePicker = datePickers.start
        let endDatePicker = datePickers.end

        startDatePicker.isEnabled = true
        endDatePicker.isEnabled = true
        
        guard let startTime = getSelectedTime(forDatePickerTag: sender.tag, isStartTime: true),
              let endtime = getSelectedTime(forDatePickerTag: sender.tag, isStartTime: false) else {
            
            return
        }

        startDatePicker.date = startTime
        endDatePicker.date = endtime
    }
    
    // Auxiliar
    private func getDatePickerSection(forDatePickerTag tag: Int) -> Int {
        let numberOfDaySections = numberOfSections(in: scheduleDetailsView.tableView) - 3
        
        var pairsArray: [[Int]] = []
        
        for pairIndex in 0..<numberOfDaySections {
            let baseIndex = pairIndex * 2
            let pair: [Int] = [baseIndex + 1, baseIndex + 2]
            pairsArray.append(pair)
        }
        
        for (index, pair) in pairsArray.enumerated() where pair.contains(tag) {
            return index
        }
        
        return 0
    }
    
    private func updateStartAndEndTime(tag: Int, date: Date) {
        let isUpdating = viewModel.isUpdatingSchedule()
        
        if isUpdating {
            switch tag {
            case 1:
                viewModel.editingScheduleStartTime = date

                if viewModel.editingScheduleEndTime <= viewModel.editingScheduleStartTime {
                    viewModel.editingScheduleEndTime = viewModel.editingScheduleStartTime.addingTimeInterval(60)
                }
            case 2:
                viewModel.editingScheduleEndTime = date

                if viewModel.editingScheduleStartTime >= viewModel.editingScheduleEndTime {
                    viewModel.editingScheduleStartTime = viewModel.editingScheduleEndTime.addingTimeInterval(-60)
                }
            default:
                break
            }
        } else {
            let section = getDatePickerSection(forDatePickerTag: tag)
            
            let startTime = viewModel.selectedDays[section].startTime
            let endTime = viewModel.selectedDays[section].endTime
            
            if !tag.isMultiple(of: 2) {
                viewModel.selectedDays[section].startTime = date
                let newStartTime = viewModel.selectedDays[section].startTime
                
                if endTime <= newStartTime {
                    viewModel.selectedDays[section].endTime = date.addingTimeInterval(60)
                }
            } else {
                viewModel.selectedDays[section].endTime = date
                let newEndTime = viewModel.selectedDays[section].endTime
                
                if startTime >= newEndTime {
                    viewModel.selectedDays[section].startTime = date.addingTimeInterval(-60)
                }
            }
        }
    }
    
    private func getDatePickers(forDatePickerTag tag: Int) -> (start: FakeDatePicker, end: FakeDatePicker)? {
        let isUpdating = viewModel.isUpdatingSchedule()
        var indexPath = IndexPath(row: 0, section: 1)
        
        if !isUpdating {
            let section = getDatePickerSection(forDatePickerTag: tag) + 1
            indexPath = IndexPath(row: 0, section: section)
        }
        
        guard let dateCell = scheduleDetailsView.tableView.cellForRow(at: indexPath) as? DateCell else {
            
            return nil
        }
        
        return (dateCell.startDatePicker, dateCell.endDatePicker)
    }
    
    private func getSelectedTime(forDatePickerTag tag: Int, isStartTime: Bool) -> Date? {
        let isUpdating = viewModel.isUpdatingSchedule()
        var startTime = Date()
        var endTime = Date()
        
        if isUpdating {
            startTime = viewModel.editingScheduleStartTime
            endTime = viewModel.editingScheduleEndTime
        } else {
            let section = getDatePickerSection(forDatePickerTag: tag)
            startTime = viewModel.selectedDays[section].startTime
            endTime = viewModel.selectedDays[section].endTime
        }
        
        return isStartTime ? startTime : endTime
    }
    
    private func getMinimumDate(forDatePickerTag tag: Int) -> Date? {
        let startTime = getSelectedTime(forDatePickerTag: tag, isStartTime: true)
        return startTime?.addingTimeInterval(60)
    }
}

extension ScheduleDetailsViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        scheduleDetailsView.newSubjectName = newText
        if newText.isEmpty {
            scheduleDetailsView.changeSaveButtonState(isEnabled: false)
        } else {
            scheduleDetailsView.changeSaveButtonState(isEnabled: true)
        }
    }
    
    func didTapSaveButton() {
        saveNewSubject()
        dismissSubjectCreationView()
    }
    
    private func saveNewSubject() {
        guard let newSubjectName = scheduleDetailsView.newSubjectName else { return }
        let cleanName = spaceRemover(string: newSubjectName)
        
        if let existingSubjects = viewModel.getSubjects(),
           existingSubjects.contains(where: { $0.name?.lowercased() == cleanName.lowercased() }) {
            
            showAlert(message: String(localized: "subjectCreationUsedName"))
            return
        }
        
        viewModel.createSubject(name: cleanName)
        viewModel.setSubjectNames()
        
        if viewModel.selectedSubjectName.isEmpty,
           let firstSubjectName = viewModel.subjectsNames.first {
            
            viewModel.selectedSubjectName = firstSubjectName
            
            updateCellAccessory(
                for: viewModel.selectedSubjectName,
                at: 0,
                color: viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName),
                isDaySection: true
            )
        }
        
        dismissSubjectCreationView()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: String(localized: "subjectCreationTitle"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapDeleteButton() {}
    
    func didTapCloseButton() {
        if viewModel.selectedSubjectName.isEmpty {
            scheduleDetailsView.changeSubjectCreationView(isShowing: false)
            return
        }
        
        dismissSubjectCreationView()
    }
    
    private func showSubjectsPopover() {
        let tableView = scheduleDetailsView.tableView
        let indexPath = IndexPath(row: 0, section: 0)
        
        if let popover = createSubjectPopover(forTableView: tableView, at: indexPath) {
            isPopoverOpen.toggle()
            present(popover, animated: true)
        }
    }
    
    private func dismissSubjectCreationView() {
        showSubjectsPopover()
        scheduleDetailsView.changeSubjectCreationView(isShowing: false)
        scheduleDetailsView.newSubjectName = nil
        scheduleDetailsView.changeSaveButtonState(isEnabled: false)
        scheduleDetailsView.reloadSubjectTable()
    }
}
