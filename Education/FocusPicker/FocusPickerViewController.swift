//
//  FocusPickerViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerViewController: UIViewController {
    weak var coordinator: Dismissing?
    let viewModel: FocusPickerViewModel
    
    private lazy var focusPickerView: FocusPickerView = {
        let view = FocusPickerView()
        view.delegate = self
        
        view.dateView.timerCase = self.viewModel.timerCase
        
        let subpickers = view.dateView.timerDatePicker.subviews.compactMap { $0 as? UIPickerView }
        for subpicker in subpickers {
            subpicker.dataSource = self
            subpicker.delegate = self
        }
        
        view.settingsTableView.dataSource = self
        view.settingsTableView.delegate = self
        view.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        return view
    }()
    
    init(viewModel: FocusPickerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.focusPickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        customBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc private func backButtonTapped() {
        self.coordinator?.dismiss()
    }
    
    @objc private func didChangeToggle(_ sender: UISwitch) {
        switch sender.tag {
            case 0:
                self.viewModel.isAlarmOn.toggle()
            case 1:
                self.viewModel.isTimeCountOn.toggle()
            default:
                break
        }
    }
}

extension FocusPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        
        cell.textLabel?.text = section == 0 ? "Alarme" : "Mostrar contagem do tempo"
        
        let toggle = UISwitch()
        toggle.isOn = section == 0 ? self.viewModel.isAlarmOn : self.viewModel.isTimeCountOn
        toggle.tag = section
        toggle.addTarget(self, action: #selector(didChangeToggle(_:)), for: .valueChanged)
        
        cell.accessoryView = toggle
        
        cell.backgroundColor = self.view.backgroundColor?.getSecondaryColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
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
        
        let unselectedColor = self.view.backgroundColor?.getDarkerColor()?.withAlphaComponent(0.5)
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let color: UIColor? = row == selectedRow ? .white : unselectedColor
        
        let fontSize = row == selectedRow ? 50.0 : 40.0
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: fontSize)
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
