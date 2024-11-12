//
//  ScheduleDetails+Picker.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - UIPickerViewDataSource and UIPickerViewDelegate

extension ScheduleDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        34
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        let numberOfSections = viewModel.numberOfSections()
        let numberOfAlarmSections = viewModel.numberOfAlarmSections()
        
        // Subjects section
        if pickerView.tag == 0 {
            return viewModel.subjectsNames.count
        } else if pickerView.tag >= (numberOfSections - 1) - numberOfAlarmSections { // Alarm section
            let numberOfDaySections = viewModel.numberOfDaySections()
            let index = pickerView.tag - 1 - numberOfDaySections
            return viewModel.filteredAlarmNames(for: index).count
        } else { // Day section
            let index = pickerView.tag - 1
            return viewModel.filteredDayNames(for: index).count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        let numberOfSections = viewModel.numberOfSections()
        let numberOfAlarmSections = viewModel.numberOfAlarmSections()

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
            pickerLabel?.textColor = .systemText50
            pickerLabel?.textAlignment = .center
        }
        
        let selectedRow = pickerView.selectedRow(inComponent: component)
        
        // Subjects section
        if pickerView.tag == 0 {
            pickerView.subviews.last?.backgroundColor = .clear
            pickerLabel?.text = viewModel.subjectsNames[row]
            updateSelectionIndicator(pickerView: pickerView, component: component, isSubject: true)
            
            if row == selectedRow {
                let subjectColorName = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
                pickerLabel?.textColor = UIColor(named: subjectColorName)?.darker(by: 0.8)
            }
        } else if pickerView.tag >= (numberOfSections - 1) - numberOfAlarmSections { // Alarm section
            var pickerLabelText = String()
            
            let numberOfDaySections = viewModel.numberOfDaySections()
            let index = pickerView.tag - 1 - numberOfDaySections
            let filteredAlarmNames = viewModel.filteredAlarmNames(for: index)
            
            pickerLabelText = filteredAlarmNames[row]
            
            pickerLabel?.text = pickerLabelText
            updateSelectionIndicator(pickerView: pickerView, component: component, isSubject: false)
            
            if row == selectedRow {
                pickerLabel?.textColor = .systemText50
            }
        } else { // Day section
            var pickerLabelText = String()
            
            let index = pickerView.tag - 1
            let filteredDayNames = viewModel.filteredDayNames(for: index)
            pickerLabelText = filteredDayNames[row]
            
            pickerLabel?.text = pickerLabelText
            updateSelectionIndicator(pickerView: pickerView, component: component, isSubject: false)
            
            if row == selectedRow {
                pickerLabel?.textColor = .systemText50
            }
        }
        
        return pickerLabel ?? UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.subviews.last?.backgroundColor = .clear
        let numberOfSections = viewModel.numberOfSections()
        let numberOfAlarmSections = viewModel.numberOfAlarmSections()
        
        // Subjects section
        if pickerView.tag == 0 {
            viewModel.selectedSubjectName = viewModel.subjectsNames[row]
                
            updateCellAccessory(
                for: viewModel.selectedSubjectName,
                at: pickerView.tag,
                color: viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName),
                isDaySection: false
            )
               
            updateSelectionIndicator(pickerView: pickerView, component: component, isSubject: true)
        } else if pickerView.tag >= (numberOfSections - 1) - numberOfAlarmSections { // Alarm section
            let numberOfDaySections = viewModel.numberOfDaySections()
            let index = pickerView.tag - 1 - numberOfDaySections
            let filteredAlarmNames = viewModel.filteredAlarmNames(for: index)
            let selectedAlarmName = filteredAlarmNames[row]
            
            guard let alarmIndex = viewModel.alarmNames.firstIndex(where: { $0 == selectedAlarmName }) else { return }
            
            let lastIndex = viewModel.selectedAlarms[index]
            viewModel.selectedAlarms[index] = alarmIndex
            let newIndex = viewModel.selectedAlarms[index]
            
            updateCellAccessory(
                for: selectedAlarmName,
                at: pickerView.tag,
                color: nil,
                isDaySection: false
            )
            
            if lastIndex == 0 || newIndex == 0 {
                reloadTable()
            }
            
            updateSelectionIndicator(pickerView: pickerView, component: component, isSubject: false)
        } else { // Day section
            let isUpdating = viewModel.isUpdatingSchedule()
            
            if isUpdating {
                viewModel.editingScheduleDay = viewModel.days[row]
                
                updateCellAccessory(
                    for: viewModel.editingScheduleDay,
                    at: pickerView.tag,
                    color: nil,
                    isDaySection: true
                )
            } else {
                let index = pickerView.tag - 1
                let filteredDayNames = viewModel.filteredDayNames(for: index)
                viewModel.selectedDays[index].name = filteredDayNames[row]
                
                updateCellAccessory(
                    for: viewModel.selectedDays[index].name,
                    at: pickerView.tag,
                    color: nil,
                    isDaySection: true
                )
            }
            
            updateSelectionIndicator(pickerView: pickerView, component: component, isSubject: false)
        }
        
        pickerView.reloadComponent(component)
    }
    
    func updateSelectionIndicator(pickerView: UIPickerView, component: Int, isSubject: Bool) {
        pickerView.subviews.filter { $0.tag == 99 }.forEach { $0.removeFromSuperview() }
        pickerView.subviews.last?.backgroundColor = .clear
        
        var color: UIColor? = .TOGGLE_BG
        
        if isSubject {
            let subjectColorName = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
            guard let baseColor = UIColor(named: subjectColorName) else { return }
            color = baseColor.withAlphaComponent(0.2)
        }
        
        let rowHeight = pickerView.rowSize(forComponent: component).height
        let selectionIndicatorY = (pickerView.bounds.height - rowHeight) / 2
        let frame = CGRect(x: 0, y: selectionIndicatorY, width: pickerView.bounds.width, height: rowHeight)
        
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = color
        overlayView.roundCorners(corners: .allCorners, radius: 10, borderWidth: 0, borderColor: .clear)
        overlayView.isUserInteractionEnabled = false
        overlayView.tag = 99
        
        pickerView.insertSubview(overlayView, at: 0)
    }
    
    func updateCellAccessory(for text: String, at section: Int, color: String?, isDaySection: Bool) {
        let indexPath = IndexPath(row: 0, section: section)
        
        if isDaySection {
            guard let cell = scheduleDetailsView.tableView.cellForRow(at: indexPath) as? DateCell else { return }

            cell.dayOfWeekTitle = text
            return
        }
        
        guard let cell = scheduleDetailsView.tableView.cellForRow(at: indexPath) as? BorderedTableCell else { return }
        
        let numberOfSections = viewModel.numberOfSections()
        let accessoryView = createAccessoryView(for: indexPath, numberOfSections: numberOfSections)
        cell.accessoryView = accessoryView
    }
}
