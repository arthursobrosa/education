//
//  FocusSessionSettings+Popover.swift
//  Education
//
//  Created by Arthur Sobrosa on 08/07/24.
//

import UIKit

// MARK: - Popover Creation
extension FocusSessionSettingsViewController {
    func createSchedulePopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
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
        
        if let selectedIndex = self.viewModel.subjectsNames.firstIndex(where: { $0 == self.viewModel.selectedSubjectName }) {
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
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPopoverOpen.toggle()
    }
}
