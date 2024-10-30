//
//  ScheduleDetails+Popover.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - Popover Creation

extension ScheduleDetailsViewController {
    func createDayPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let section = indexPath.section

        let popoverVC = Popover(contentSize: CGSize(width: 200, height: 150))
        let sourceRect = CGRect(x: cell.bounds.maxX - 28,
                                y: cell.bounds.midY,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)

        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = section

        popoverVC.view = dayPicker

        let items = viewModel.days
        let selectedItem = viewModel.selectedDay

        if let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) {
            dayPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }

        return popoverVC
    }

    func createSubjectPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let section = indexPath.section

        let popoverVC = Popover(contentSize: CGSize(width: 200, height: 150))
        let sourceRect = CGRect(x: cell.bounds.maxX - 28,
                                y: cell.bounds.midY,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)

        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = section

        popoverVC.view = dayPicker

        let items = viewModel.subjectsNames
        let selectedItem = viewModel.selectedSubjectName

        if let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) {
            dayPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }

        return popoverVC
    }
}

// MARK: - Popover Delegate

extension ScheduleDetailsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func presentationControllerDidDismiss(_: UIPresentationController) {
        isPopoverOpen.toggle()
    }
}
