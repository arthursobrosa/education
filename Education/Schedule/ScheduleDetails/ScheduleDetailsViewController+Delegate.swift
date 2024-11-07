//
//  ScheduleDetailsViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

@objc
protocol ScheduleDetailsDelegate: AnyObject {
    func deleteSchedule()
    func saveSchedule()
    func getSubjectColors() -> [String]
    func getSelectedSubjectColor() -> String
    func setSelectedSubjectColor(_ color: String)
    func showColorPopover()
    func dismissColorPopover()
}

extension ScheduleDetailsViewController: ScheduleDetailsDelegate {
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

        if viewModel.selectedStartTime >= viewModel.selectedEndTime {
            showInvalidDatesAlert(forExistingSchedule: false)
            return
        }

        if !viewModel.isNewScheduleAvailable() {
            showInvalidDatesAlert(forExistingSchedule: true)
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
    
    #warning("missing alert when there is already a subject with this name")
    private func saveNewSubject() {
        guard let newSubjectName = scheduleDetailsView.newSubjectName else { return }
        let cleanName = spaceRemover(string: newSubjectName)

//        let existingSubjects = viewModel.subjects.value
//        
//        if existingSubjects.contains(where: { $0.name?.lowercased() == cleanName.lowercased() }) {
//            showAlert(message: String(localized: "subjectCreationUsedName"))
//            return
//        }

        viewModel.createSubject(name: cleanName)
        viewModel.fetchSubjects()
        dismissSubjectCreationView()
    }
    
    func didTapDeleteButton() {}
    
    func didTapCloseButton() {
        dismissSubjectCreationView()
    }
    
    private func showSubjectsPopover() {
        let tableView = scheduleDetailsView.tableView
        let indexPath = IndexPath(row: 0, section: 1)
        
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
