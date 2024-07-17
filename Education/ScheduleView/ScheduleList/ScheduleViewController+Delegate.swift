//
//  ScheduleViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

protocol ScheduleDelegate: AnyObject {
    func setPicker(_ picker: UIStackView)
}

protocol DayDelegate: AnyObject {
    func dayTapped(_ dayView: DayView)
}

extension ScheduleViewController: ScheduleDelegate {
    func setPicker(_ picker: UIStackView) {
        let dates = self.viewModel.daysOfWeek
        
        for (index, date) in dates.enumerated() {
            let dayView = DayView()
            
            let dayString = self.viewModel.dayAbbreviation(date)
            let dateString = self.viewModel.dayFormatted(date)
            let isSelected = self.viewModel.selectedDay == Calendar.current.component(.weekday, from: date) - 1
            dayView.dayOfWeek = DayOfWeek(day: dayString, date: dateString, isSelected: isSelected)
            
            dayView.tag = index
            dayView.delegate = self
            
            picker.addArrangedSubview(dayView)
        }
    }
}

extension ScheduleViewController: DayDelegate {
    func dayTapped(_ dayView: DayView) {
        self.unselectDays()
        
        guard let dayOfWeek = dayView.dayOfWeek else { return }
        
        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true)
        self.viewModel.selectedDay = dayView.tag
        self.viewModel.fetchSchedules()
        self.reloadTable()
    }
}
