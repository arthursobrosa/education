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

        let size = CGSize(width: cell.bounds.width, height: cell.bounds.width * (180 / 345))
        let popoverVC = Popover(contentSize: size)
        let sourceRect = CGRect(
            x: cell.bounds.midX,
            y: cell.bounds.maxY + size.height / 2 + 16,
            width: 0,
            height: 0
        )

        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: [], sourceRect: sourceRect, delegate: self)
        let containerView = UIView(frame: CGRect(origin: .zero, size: size))
        
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

        let selectedIndex = viewModel.selectedSubjectInfo.index
        picker.selectRow(selectedIndex, inComponent: 0, animated: true)

        return popoverVC
    }
}

// MARK: - Popover Delegate

extension FocusEndViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
