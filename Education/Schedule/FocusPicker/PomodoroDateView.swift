//
//  PomodoroDateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/09/24.
//

import UIKit

class PomodoroDateView: UIView {
    let workDatePicker: CustomDatePickerView = {
        let picker = CustomDatePickerView()
        
        picker.hoursPicker.tag = PickerCase.workHours
        picker.minutesPicker.tag = PickerCase.workMinutes
        
        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()
    
    let restDatePicker: CustomDatePickerView = {
        let picker = CustomDatePickerView()
        
        picker.hoursPicker.tag = PickerCase.restHours
        picker.minutesPicker.tag = PickerCase.restMinutes
        
        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()
    
    let repetitionsPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = PickerCase.repetitions
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    enum StackCase {
        case work
        case rest
        case repetition
        
        var name: String {
            switch self {
                case .work:
                    return "Foco"
                case .rest:
                    return "Intervalo"
                case .repetition:
                    return "Repetições"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.repetitionsPicker.subviews {
            subview.backgroundColor = .clear
        }
    }
}

extension PomodoroDateView: ViewCodeProtocol {
    func setupUI() {
        guard let focusStack = self.setupStack(.work),
              let intervalStack = self.setupStack(.rest),
              let repetitionsStack = self.setupStack(.repetition) else { return }
        
        self.addSubview(focusStack)
        self.addSubview(intervalStack)
        self.addSubview(repetitionsStack)
        
        NSLayoutConstraint.activate([
            focusStack.topAnchor.constraint(equalTo: self.topAnchor),
            focusStack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 92/293),
            focusStack.widthAnchor.constraint(equalTo: self.widthAnchor),
            focusStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            intervalStack.topAnchor.constraint(equalTo: focusStack.bottomAnchor),
            intervalStack.heightAnchor.constraint(equalTo: focusStack.heightAnchor),
            intervalStack.widthAnchor.constraint(equalTo: focusStack.widthAnchor),
            intervalStack.centerXAnchor.constraint(equalTo: focusStack.centerXAnchor),
            
            repetitionsStack.topAnchor.constraint(equalTo: intervalStack.bottomAnchor),
            repetitionsStack.heightAnchor.constraint(equalTo: intervalStack.heightAnchor),
            repetitionsStack.widthAnchor.constraint(equalTo: intervalStack.widthAnchor),
            repetitionsStack.centerXAnchor.constraint(equalTo: intervalStack.centerXAnchor)
        ])
    }
    
    private func setupStack(_ stackCase: StackCase) -> UIView? {
        let stack = UIView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let label = self.createLabel(withText: stackCase.name)
        stack.addSubview(label)
        
        var pickerWidthMultiplier = 0.6
        
        switch stackCase {
            case .work:
                stack.addSubview(self.workDatePicker)
            case .rest:
                stack.addSubview(self.restDatePicker)
            case .repetition:
                stack.addSubview(self.repetitionsPicker)
                pickerWidthMultiplier = 0.2
        }
        
        guard let picker = stack.subviews.last else { return nil }
        
        let pickerHorizontalConstraint = stackCase == .repetition ? picker.centerXAnchor.constraint(equalTo: stack.centerXAnchor, constant: -4) : picker.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -4)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            
            pickerHorizontalConstraint,
            picker.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
            picker.heightAnchor.constraint(equalTo: stack.heightAnchor),
            picker.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: pickerWidthMultiplier)
        ])
        
        return stack
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textColor = .label.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
