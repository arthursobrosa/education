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
                switch row {
                    case 0:
                        return String(localized: "date")
                    case 1:
                        return String(localized: "startDate")
                    case 2:
                        return String(localized: "endDate")
                    default:
                        return String()
                }
            case 1:
                return row == 0 ? String(localized: "alarm5Min") : String(localized: "alarmAtTime")
            case 2:
                return String(localized: "subject")
            case 3:
                return String(localized: "blockApps")
            default:
                return String()
        }
    }
    
    @objc private func switchToggledBefore(_ sender: UISwitch) {
        self.viewModel.alarmBefore = sender.isOn
        
        guard self.viewModel.alarmBefore else { return }
        
        NotificationService.shared.requestAuthorization { granted, error in
            if granted {
                print("notification persimission granted")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func switchToggledInTime(_ sender: UISwitch){
        self.viewModel.alarmInTime = sender.isOn
    }
    
    @objc private func switchToggledBlockApps(_ sender: UISwitch) {
        self.viewModel.blocksApps = sender.isOn
    }
    
    func createAttributedLabel(withText text: String, symbolName: String, symbolColor: UIColor, textColor: UIColor) -> UIView {
        let label = UILabel()
        
        // Cria a string de texto com a cor do texto
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor
        ]
        let textString = NSAttributedString(string: "\(text) ", attributes: textAttributes)
        
        // Cria o NSTextAttachment para o símbolo
        let attachment = NSTextAttachment()
        let image = UIImage(systemName: symbolName)?.withTintColor(symbolColor, renderingMode: .alwaysOriginal)
        attachment.image = image
        let imageString = NSAttributedString(attachment: attachment)
        
        // Combina o texto e o símbolo
        let combinedString = NSMutableAttributedString()
        combinedString.append(textString)
        combinedString.append(imageString)
        
        // Configura o UILabel
        label.attributedText = combinedString
        label.sizeToFit()
        
        // Cria uma UIView e adiciona o UILabel a ela
        let containerView = UIView(frame: label.bounds)
        containerView.addSubview(label)
        
        return containerView
    }
    
    func createAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                if row == 0 {
                    let containerView = createAttributedLabel(withText: "\(self.viewModel.selectedDay)", symbolName: "chevron.up.chevron.down", symbolColor: .secondaryLabel,  textColor: .secondaryLabel)
                    return containerView
                }
            
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                datePicker.date = row == 1 ? self.viewModel.selectedStartTime : self.viewModel.selectedEndTime
                datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                datePicker.tag = row
                
                return datePicker
            case 1:
                if row == 0 {
                    let toggleSwitch = UISwitch()
                    toggleSwitch.addTarget(self, action: #selector(switchToggledBefore(_:)), for: .valueChanged)
                    
                    return toggleSwitch
                }
                
                let toggleSwitch = UISwitch()
                toggleSwitch.addTarget(self, action: #selector(switchToggledInTime(_:)), for: .valueChanged)
                
                return toggleSwitch
            case 2:
                let containerView = createAttributedLabel(withText: "\(self.viewModel.selectedSubjectName)", symbolName: "chevron.up.chevron.down", symbolColor: .secondaryLabel, textColor: .secondaryLabel)
                
                return containerView
            case 3:
                let toggle = UISwitch()
                toggle.isOn = self.viewModel.blocksApps
                toggle.addTarget(self, action: #selector(switchToggledBlockApps(_:)), for: .touchUpInside)
                
                return toggle
            default:
                return nil
        }
    }
}
