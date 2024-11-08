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
        // Subjects section
        if pickerView.tag == 0 {
            return viewModel.subjectsNames.count
        } else { // day section
            let index = pickerView.tag - 1
            return viewModel.filteredDayNames(for: index).count
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

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
            updateSubjectSelectionIndicator(pickerView: pickerView, component: component)
            
            if row == selectedRow {
                let subjectColorName = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
                pickerLabel?.textColor = UIColor(named: subjectColorName)?.darker(by: 0.8)
            }
        } else { // Day section
            let isUpdating = viewModel.isUpdatingSchedule()
            var pickerLabelText = String()
            
            if isUpdating {
                pickerLabelText = viewModel.days[row]
            } else {
                let filteredDayNames = viewModel.filteredDayNames(for: pickerView.tag - 1)
                pickerLabelText = filteredDayNames[row]
            }
            
            pickerLabel?.text = pickerLabelText
            updateDaySelectionIndicator(pickerView: pickerView, component: component)
            
            if row == selectedRow {
                pickerLabel?.textColor = .systemText50
            }
        }
        
        return pickerLabel ?? UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.subviews.last?.backgroundColor = .clear
        
        // Subjects section
        if pickerView.tag == 0 {
            viewModel.selectedSubjectName = viewModel.subjectsNames[row]
                
            updateCellAccessory(
                for: viewModel.selectedSubjectName,
                at: pickerView.tag,
                color: viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
            )
                
            updateSubjectSelectionIndicator(pickerView: pickerView, component: component)
        } else { // Day section
            let isUpdating = viewModel.isUpdatingSchedule()
            
            if isUpdating {
                viewModel.editingScheduleDay = viewModel.days[row]
                updateCellAccessory(for: viewModel.editingScheduleDay, at: pickerView.tag, color: nil)
            } else {
                let index = pickerView.tag - 1
                let filteredDayNames = viewModel.filteredDayNames(for: index)
                viewModel.selectedDays[index].name = filteredDayNames[row]
                updateCellAccessory(for: viewModel.selectedDays[index].name, at: pickerView.tag, color: nil)
            }
            
            updateDaySelectionIndicator(pickerView: pickerView, component: component)
        }
        
        pickerView.reloadComponent(component)
    }
    
    func updateSubjectSelectionIndicator(pickerView: UIPickerView, component: Int) {
        pickerView.subviews.filter { $0.tag == 99 }.forEach { $0.removeFromSuperview() }
        pickerView.subviews.last?.backgroundColor = .clear

        let subjectColorName = viewModel.getColorBySubjectName(name: viewModel.selectedSubjectName)
        guard let baseColor = UIColor(named: subjectColorName) else { return }
        let color = baseColor.withAlphaComponent(0.2)
        
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
    
    private func updateDaySelectionIndicator(pickerView: UIPickerView, component: Int) {
        pickerView.subviews.filter { $0.tag == 99 }.forEach { $0.removeFromSuperview() }
        pickerView.subviews.last?.backgroundColor = .clear
        
        let rowHeight = pickerView.rowSize(forComponent: component).height
        let selectionIndicatorY = (pickerView.bounds.height - rowHeight) / 2
        let frame = CGRect(x: 0, y: selectionIndicatorY, width: pickerView.bounds.width, height: rowHeight)
        
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = .TOGGLE_BG
        overlayView.roundCorners(corners: .allCorners, radius: 10, borderWidth: 0, borderColor: .clear)
        overlayView.isUserInteractionEnabled = false
        overlayView.tag = 99
        
        pickerView.insertSubview(overlayView, at: 0)
    }
    
    func updateCellAccessory(for text: String, at section: Int, color: String?) {
        guard let cell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? DateCell else { return }

        cell.dayOfWeekTitle = text
    }
}
