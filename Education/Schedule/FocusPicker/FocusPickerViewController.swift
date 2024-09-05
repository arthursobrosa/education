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
    
    private let color: UIColor?
    
    private lazy var focusPickerView: FocusPickerView = {
        let view = FocusPickerView(color: self.color, timerCase: self.viewModel.focusSessionModel.timerCase)
        view.delegate = self
        
        let subpickers = view.dateView.timerDatePicker.subviews.compactMap { $0 as? UIPickerView }
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
    
    init(viewModel: FocusPickerViewModel, color: UIColor?) {
        self.viewModel = viewModel
        self.color = color
        
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
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.focusPickerView.layer.borderColor = UIColor.label.cgColor
        }
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
}

extension FocusPickerViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(focusPickerView)
        
        NSLayoutConstraint.activate([
            focusPickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: (542/844)),
            focusPickerView.widthAnchor.constraint(equalTo: focusPickerView.heightAnchor, multiplier: (366/542)),
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
        cell.roundCorners(corners: .allCorners, radius: 14.0, borderWidth: 1, borderColor: .secondaryLabel)
        
        let toggle = UISwitch()
        toggle.isOn = toggleIsOn
        toggle.tag = section
        toggle.addTarget(self, action: #selector(didChangeToggle(_:)), for: .valueChanged)
        toggle.onTintColor = UIColor(named: "turquoisePicker")
        
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
        return pickerView.tag == 0 ? self.viewModel.hours.count : self.viewModel.minutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let selection = pickerView.tag == 0 ? self.viewModel.hours[row] : self.viewModel.minutes[row]
        let text = selection < 10 ? "0" + String(selection) : String(selection)
        
        let unselectedColor = self.color?.darker(by: 0.6)?.withAlphaComponent(0.5)
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let color: UIColor? = row == selectedRow ? .white : unselectedColor
        
        let fontSize = row == selectedRow ? 50.0 : 40.0
        
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: .semibold)
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
            case 0:
                self.viewModel.selectedHours = self.viewModel.hours[row]
            case 1:
                self.viewModel.selectedMinutes = self.viewModel.minutes[row]
            default:
                break
        }
        
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50
    }
}
