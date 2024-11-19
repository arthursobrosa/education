//
//  StudyTimeViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

@objc
protocol StudyTimeDelegate: AnyObject {
    func setSegmentedControl(_ picker: UISegmentedControl)
    func plusButtonTapped()
}

extension StudyTimeViewController: StudyTimeDelegate {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let dateRanges = viewModel.dateRanges.map { $0.name }
        let selectedDateRange = viewModel.selectedDateRange.name

        for (index, dateRange) in dateRanges.enumerated() {
            let action = UIAction(title: dateRange) { _ in
                self.viewModel.selectedDateRange = self.viewModel.dateRanges[index]
            }

            segmentedControl.insertSegment(action: action, at: index, animated: false)

            if dateRange == selectedDateRange {
                segmentedControl.selectedSegmentIndex = index
            }
        }

        let fontRegular = UIFont(name: Fonts.darkModeOnRegular, size: 13)
        let fontBold = UIFont(name: Fonts.darkModeOnSemiBold, size: 13)

        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: fontRegular ?? UIFont.systemFont(ofSize: 13),
        ]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)

        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: fontBold ?? UIFont.systemFont(ofSize: 13),
        ]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    func plusButtonTapped() {
        viewModel.currentEditingSubject = nil
        viewModel.selectedSubjectColor.value = viewModel.selectAvailableColor()
        coordinator?.showSubjectCreation(viewModel: viewModel)
    }
}
