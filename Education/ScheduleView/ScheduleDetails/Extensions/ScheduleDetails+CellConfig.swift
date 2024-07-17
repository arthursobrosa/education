//
//  ScheduleDetails+CellConfig.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

extension ScheduleDetailsViewController {
    func createCellTitle(for indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                return self.viewModel.subjectsNames.isEmpty ?  "Add Subject" : (row == 0 ? "Add Subject" : self.viewModel.selectedSubjectName)
            case 1:
                return self.viewModel.selectedDay
            case 2:
                return row == 0 ? "Start" : "End"
            default:
                return String()
        }
    }
    
    func createAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                let systemName = self.viewModel.subjectsNames.isEmpty ? "plus" : (row == 0 ? "plus" : "chevron.down")
                return UIImageView(image: UIImage(systemName: systemName))
            case 1:
                return UIImageView(image: UIImage(systemName: "chevron.down"))
            case 2:
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                datePicker.date = row == 0 ? self.viewModel.selectedStartTime : self.viewModel.selectedEndTime
                datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                datePicker.tag = row
                return datePicker
            default:
                return nil
        }
    }
}
