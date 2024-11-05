//
//  FocusEnd+Popover.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/11/24.
//

import UIKit

extension FocusEndViewController {
    func createSubjectsPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let section = indexPath.section

        let popoverVC = Popover(contentSize: CGSize(width: 159, height: 180))
        let sourceRect = CGRect(
            x: cell.bounds.maxX,
            y: cell.bounds.maxY + cell.bounds.height,
            width: 0,
            height: 0
        )

        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: [], sourceRect: sourceRect, delegate: self)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 159, height: 180))
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = section
        picker.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(picker)
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: containerView.topAnchor),
            picker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            picker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
        ])
        
        popoverVC.view = containerView

        let items = viewModel.subjectNames
        let selectedItem = viewModel.selectedSubjectInfo.name

        if let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) {
            picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }

        return popoverVC
    }
}

// MARK: - Popover Delegate

extension FocusEndViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
