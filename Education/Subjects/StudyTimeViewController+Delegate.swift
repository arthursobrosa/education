//
//  StudyTimeViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

protocol StudyTimeDelegate: AnyObject {
    func setPicker(_ picker: UISegmentedControl)
}

extension StudyTimeViewController: StudyTimeDelegate {
    func setPicker(_ picker: UISegmentedControl) {
        let dateRanges = self.viewModel.dateRanges.map { $0.name }
        let selectedDateRange = self.viewModel.selectedDateRange.name
        
        for (index, dateRange) in dateRanges.enumerated() {
            let action = UIAction(title: dateRange) { _ in
                self.viewModel.selectedDateRange = self.viewModel.dateRanges[index]
            }
            
            picker.insertSegment(action: action, at: index, animated: false)
            
            if dateRange == selectedDateRange {
                picker.selectedSegmentIndex = index
            }
        }
    }
}
