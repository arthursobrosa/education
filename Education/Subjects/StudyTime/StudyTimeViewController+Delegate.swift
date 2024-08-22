//
//  StudyTimeViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

protocol StudyTimeDelegate: AnyObject {
    func setSegmentedControl(_ picker: UISegmentedControl)
}

extension StudyTimeViewController: StudyTimeDelegate {
    func setSegmentedControl(_ segmentedControl: UISegmentedControl) {
        let dateRanges = self.viewModel.dateRanges.map { $0.name }
        let selectedDateRange = self.viewModel.selectedDateRange.name
        
        for (index, dateRange) in dateRanges.enumerated() {
            let action = UIAction(title: dateRange) { _ in
                self.viewModel.selectedDateRange = self.viewModel.dateRanges[index]
            }
            
            segmentedControl.insertSegment(action: action, at: index, animated: false)
            
            if dateRange == selectedDateRange {
                segmentedControl.selectedSegmentIndex = index
            }
        }
    }
}
