//
//  FocusPickerViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerViewController: UIViewController {
    weak var coordinator: (ShowingTimer & Dismissing & DismissingAll)?
    let viewModel: FocusPickerViewModel
    
    private lazy var focusPickerView: FocusPickerView = {
        let view = FocusPickerView(timerCase: self.viewModel.focusSessionModel.timerCase)
        view.delegate = self
        
        let subviews = view.dateView.timerDatePicker.subviews + view.dateView.pomodoroDateView.workDatePicker.subviews + view.dateView.pomodoroDateView.restDatePicker.subviews
        var subpickers = subviews.compactMap { $0 as? UIPickerView }
        subpickers.append(view.dateView.pomodoroDateView.repetitionsPicker)
        for subpicker in subpickers {
            subpicker.dataSource = self
            subpicker.delegate = self
        }
        
        view.settingsTableView.dataSource = self
        view.settingsTableView.delegate = self
        view.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: FocusPickerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.traitCollection.userInterfaceStyle == .light){
            self.view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            self.view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configurePomodoroPickers()
    }
    
    @objc private func didChangeToggle(_ sender: UISwitch) {
        switch sender.tag {
            case 0:
                self.viewModel.focusSessionModel.isAlarmOn.toggle()
            case 1:
                self.viewModel.focusSessionModel.isTimeCountOn.toggle()
            case 2:
                self.viewModel.focusSessionModel.blocksApps.toggle()
            default:
                break
        }
    }
    
    private func configurePomodoroPickers() {
        let timerCase = self.viewModel.focusSessionModel.timerCase
        
        var workSeconds = Int()
        var restSeconds = Int()
        var repetitions = Int()
        
        switch timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                workSeconds = workTime
                restSeconds = restTime
                repetitions = numberOfLoops - 1
            default:
                return
        }
        
        var hoursAndMinutes = self.viewModel.getHoursAndMinutes(from: workSeconds)
        
        self.selectRow(hoursAndMinutes[0], in: self.focusPickerView.dateView.pomodoroDateView.workDatePicker.hoursPicker)
        self.selectRow(hoursAndMinutes[1] - 1, in: self.focusPickerView.dateView.pomodoroDateView.workDatePicker.minutesPicker)
        
        hoursAndMinutes = self.viewModel.getHoursAndMinutes(from: restSeconds)
        
        self.selectRow(hoursAndMinutes[0], in: self.focusPickerView.dateView.pomodoroDateView.restDatePicker.hoursPicker)
        self.selectRow(hoursAndMinutes[1] - 1, in: self.focusPickerView.dateView.pomodoroDateView.restDatePicker.minutesPicker)
        
        self.selectRow(repetitions - 1, in: self.focusPickerView.dateView.pomodoroDateView.repetitionsPicker)
    }
    
    private func selectRow(_ row: Int, in picker: UIPickerView) {
        picker.selectRow(row, inComponent: 0, animated: false)
    }
}

extension FocusPickerViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(focusPickerView)
        
        let timerCase = self.viewModel.focusSessionModel.timerCase
        
        var heightMultiplier = Double()
        var widthMultiplier = Double()
        
        switch timerCase {
            case .timer:
                heightMultiplier = 542/844
                widthMultiplier = 366/542
                self.focusPickerView.titleText.text = String(localized: "timerSelectionBold")
            case .pomodoro:
                heightMultiplier = 696/844
                widthMultiplier = 366/696
                self.focusPickerView.titleText.text = String(localized: "pomodoroSelectionTitle")
            default:
                break
        }
        
        NSLayoutConstraint.activate([
            focusPickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: heightMultiplier),
            focusPickerView.widthAnchor.constraint(equalTo: focusPickerView.heightAnchor, multiplier: widthMultiplier),
            focusPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            focusPickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension FocusPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        
        var toggleIsOn = Bool()
        var cellText = String()
        
        switch section {
            case 0:
                cellText = String(localized: "alarm")
                toggleIsOn = self.viewModel.focusSessionModel.isAlarmOn
            case 1:
                cellText = String(localized: "showTimeCount")
                toggleIsOn = self.viewModel.focusSessionModel.isTimeCountOn
            case 2:
                cellText = String(localized: "blockApps")
                toggleIsOn = self.viewModel.focusSessionModel.blocksApps
            default:
                break
        }
        
        cell.textLabel?.text = cellText
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        cell.backgroundColor = .systemBackground
        cell.roundCorners(corners: .allCorners, radius: 14.0, borderWidth: 2.5, borderColor: .systemGray4)
        
        let toggle = UISwitch()
        toggle.isOn = toggleIsOn
        toggle.tag = section
        toggle.addTarget(self, action: #selector(didChangeToggle(_:)), for: .valueChanged)
        toggle.onTintColor = UIColor(named: "bluePicker")
        
        cell.accessoryView = toggle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 0, 1:
                return 6
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}

extension FocusPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            case PickerCase.timerHours, PickerCase.workHours, PickerCase.restHours:
                return self.viewModel.hours.count
            case PickerCase.timerMinutes, PickerCase.workMinutes, PickerCase.restMinutes:
                return self.viewModel.minutes.count
            case PickerCase.repetitions:
                return self.viewModel.repetitions.count
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var selection = Int()
        
        switch pickerView.tag {
            case PickerCase.timerHours, PickerCase.workHours, PickerCase.restHours:
                selection = self.viewModel.hours[row]
            case PickerCase.timerMinutes, PickerCase.workMinutes, PickerCase.restMinutes:
                selection = self.viewModel.minutes[row]
            case PickerCase.repetitions:
                selection = self.viewModel.repetitions[row]
            default:
                break
        }
        
        let text = selection < 10 ? "0" + String(selection) : String(selection)
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let color: UIColor? = row == selectedRow ? .label : .secondaryLabel
        
        let fontSize = row == selectedRow ? 30.0 : 24.0
        
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: fontSize)
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
            case PickerCase.timerHours:
                self.viewModel.selectedTimerHours = self.viewModel.hours[row]
            case PickerCase.timerMinutes:
                self.viewModel.selectedTimerMinutes = self.viewModel.minutes[row]
            case PickerCase.workHours:
                self.viewModel.selectedWorkHours = self.viewModel.hours[row]
            case PickerCase.workMinutes:
                self.viewModel.selectedWorkMinutes = self.viewModel.minutes[row]
            case PickerCase.restHours:
                self.viewModel.selectedRestHours = self.viewModel.hours[row]
            case PickerCase.restMinutes:
                self.viewModel.selectedRestMinutes = self.viewModel.minutes[row]
            case PickerCase.repetitions:
                self.viewModel.selectedRepetitions = self.viewModel.repetitions[row]
            default:
                break
        }
        
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        30
    }
}
