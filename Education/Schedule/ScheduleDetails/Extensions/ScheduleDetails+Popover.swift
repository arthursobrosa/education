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

        let popoverVC = Popover(contentSize: CGSize(width: 159, height: 180))
        let sourceRect = CGRect(x: cell.bounds.maxX,
                                y: cell.bounds.midY + 120,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: [], sourceRect: sourceRect, delegate: self)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 159, height: 180))
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = section
        dayPicker.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dayPicker)
        
        NSLayoutConstraint.activate([
            dayPicker.topAnchor.constraint(equalTo: containerView.topAnchor),
            dayPicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            dayPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
        ])
        
        popoverVC.view = containerView

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

        let popoverVC = Popover(contentSize: CGSize(width: 159, height: 180))
        let sourceRect = CGRect(x: cell.bounds.maxX,
                                y: cell.bounds.midY + 120,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: [], sourceRect: sourceRect, delegate: self)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 159, height: 180))
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = section
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        
        let createNewButton = UIButton(type: .system)
        createNewButton.setTitle("Criar Nova", for: .normal)
        createNewButton.tintColor = .bluePicker
        createNewButton.titleLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
        createNewButton.addTarget(self, action: #selector(createNewButtonTapped), for: .touchUpInside)
        createNewButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(dayPicker)
        containerView.addSubview(createNewButton)
        
        NSLayoutConstraint.activate([
            dayPicker.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            dayPicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            dayPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            dayPicker.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 138 / 180),
            
            createNewButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            createNewButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -11),
            createNewButton.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        popoverVC.view = containerView

        let items = viewModel.subjectsNames
        let selectedItem = viewModel.selectedSubjectName

        if let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) {
            dayPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }

        return popoverVC
    }
    
    @objc func createNewButtonTapped() {
        print("Create New button tapped")
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
