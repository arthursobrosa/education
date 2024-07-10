//
//  FocusSessionSettings+Popover.swift
//  Education
//
//  Created by Arthur Sobrosa on 08/07/24.
//

import UIKit

// MARK: - Popover Creation
extension FocusSessionSettingsViewController {
    func createSubjectPopover(forTableView tableView: UITableView) -> Popover? {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else { return nil }
        
        let popoverVC = Popover(contentSize: CGSize(width: 200, height: 150))
        let sourceRect = CGRect(x: cell.bounds.midX,
                                y: cell.bounds.midY,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)
        
        let subjectPicker = UIPickerView()
        subjectPicker.delegate = self
        subjectPicker.dataSource = self
        
        popoverVC.view = subjectPicker
        
        if let selectedIndex = self.viewModel.subjects.firstIndex(where: { $0 == self.viewModel.selectedSubject.value }) {
            subjectPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }
        
        return popoverVC
    }
}

// MARK: - Popover Delegate
extension FocusSessionSettingsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
