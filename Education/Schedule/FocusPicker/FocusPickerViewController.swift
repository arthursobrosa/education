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
        let view = FocusPickerView(timerCase: viewModel.focusSessionModel.timerCase)
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            view.backgroundColor = .label.withAlphaComponent(0.1)
        }

        setupUI()
        setGestureRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureTimerPicker()
        configurePomodoroPickers()
    }

    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)

        guard !focusPickerView.frame.contains(tapLocation) else { return }

        coordinator?.dismissAll()
    }

    @objc private func didChangeToggle(_ sender: UISwitch) {
        switch sender.tag {
        case 0:
            viewModel.focusSessionModel.isAlarmOn.toggle()
        case 1:
            viewModel.focusSessionModel.isTimeCountOn.toggle()
        case 2:
            viewModel.focusSessionModel.blocksApps.toggle()
        default:
            break
        }
    }

    private func configureTimerPicker() {
        selectRow(viewModel.selectedTimerHours, in: focusPickerView.dateView.timerDatePicker.hoursPicker)
        selectRow(viewModel.selectedTimerMinutes, in: focusPickerView.dateView.timerDatePicker.minutesPicker)
    }

    private func configurePomodoroPickers() {
        guard case let .pomodoro(workTime, restTime, numberOfLoops) = viewModel.focusSessionModel.timerCase else { return }

        let repetitions = numberOfLoops - 1

        var hoursAndMinutes = viewModel.getHoursAndMinutes(from: workTime)

        selectRow(hoursAndMinutes.hours, in: focusPickerView.dateView.pomodoroDateView.workDatePicker.hoursPicker)
        selectRow(hoursAndMinutes.minutes, in: focusPickerView.dateView.pomodoroDateView.workDatePicker.minutesPicker)

        hoursAndMinutes = viewModel.getHoursAndMinutes(from: restTime)

        selectRow(hoursAndMinutes.hours, in: focusPickerView.dateView.pomodoroDateView.restDatePicker.hoursPicker)
        selectRow(hoursAndMinutes.minutes, in: focusPickerView.dateView.pomodoroDateView.restDatePicker.minutesPicker)

        selectRow(repetitions - 1, in: focusPickerView.dateView.pomodoroDateView.repetitionsPicker)
    }

    private func selectRow(_ row: Int, in picker: UIPickerView) {
        picker.selectRow(row, inComponent: 0, animated: false)
    }
}

extension FocusPickerViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(focusPickerView)

        let timerCase = viewModel.focusSessionModel.timerCase

        var heightMultiplier = Double()
        var widthMultiplier = Double()

        switch timerCase {
        case .timer:
            heightMultiplier = 542 / 844
            widthMultiplier = 366 / 542
            focusPickerView.titleLabel.text = String(localized: "timerSelectionBold")
        case .pomodoro:
            heightMultiplier = 696 / 844
            widthMultiplier = 366 / 696
            focusPickerView.titleLabel.text = String(localized: "pomodoroSelectionTitle")
        default:
            break
        }

        NSLayoutConstraint.activate([
            focusPickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier),
            focusPickerView.widthAnchor.constraint(equalTo: focusPickerView.heightAnchor, multiplier: widthMultiplier),
            focusPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension FocusPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
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
            toggleIsOn = viewModel.focusSessionModel.isAlarmOn
        case 1:
            cellText = String(localized: "showTimeCount")
            toggleIsOn = viewModel.focusSessionModel.isTimeCountOn
        case 2:
            cellText = String(localized: "blockApps")
            toggleIsOn = viewModel.focusSessionModel.blocksApps
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

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 0
    }

    func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 6
        default:
            return 0
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}

extension FocusPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        switch pickerView.tag {
        case PickerCase.timerHours, PickerCase.workHours, PickerCase.restHours:
            return viewModel.hours.count
        case PickerCase.timerMinutes, PickerCase.workMinutes, PickerCase.restMinutes:
            return viewModel.minutes.count
        case PickerCase.repetitions:
            return viewModel.repetitions.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing _: UIView?) -> UIView {
        var selection = 0

        switch pickerView.tag {
        case PickerCase.timerHours, PickerCase.workHours, PickerCase.restHours:
            selection = viewModel.hours[row]
        case PickerCase.timerMinutes, PickerCase.workMinutes, PickerCase.restMinutes:
            selection = viewModel.minutes[row]
        case PickerCase.repetitions:
            selection = viewModel.repetitions[row]
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        switch pickerView.tag {
        case PickerCase.timerHours:
            viewModel.selectedTimerHours = viewModel.hours[row]
        case PickerCase.timerMinutes:
            viewModel.selectedTimerMinutes = viewModel.minutes[row]
        case PickerCase.workHours:
            viewModel.selectedWorkHours = viewModel.hours[row]
        case PickerCase.workMinutes:
            viewModel.selectedWorkMinutes = viewModel.minutes[row]
        case PickerCase.restHours:
            viewModel.selectedRestHours = viewModel.hours[row]
        case PickerCase.restMinutes:
            viewModel.selectedRestMinutes = viewModel.minutes[row]
        case PickerCase.repetitions:
            viewModel.selectedRepetitions = viewModel.repetitions[row]
        default:
            break
        }

        changeStartButtonState(for: pickerView.tag)
        pickerView.reloadAllComponents()
    }

    func pickerView(_: UIPickerView, rowHeightForComponent _: Int) -> CGFloat {
        30
    }

    private func changeStartButtonState(for tag: Int) {
        switch tag {
        case PickerCase.timerHours, PickerCase.timerMinutes:
            if viewModel.selectedTimerHours == 0 && viewModel.selectedTimerMinutes == 0 {
                focusPickerView.changeStartButtonState(isEnabled: false)
                return
            }
        case PickerCase.workHours, PickerCase.workMinutes, PickerCase.restHours, PickerCase.restMinutes:
            if (viewModel.selectedWorkHours == 0 && viewModel.selectedWorkMinutes == 0) || (viewModel.selectedRestHours == 0 && viewModel.selectedRestMinutes == 0) {
                focusPickerView.changeStartButtonState(isEnabled: false)
                return
            }
        default:
            return
        }

        focusPickerView.changeStartButtonState(isEnabled: true)
    }
}
