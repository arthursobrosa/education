//
//  FocusExtensionAlertView.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/10/24.
//

import UIKit

enum FocusExtensionAlertCase {
    case timer
    case pomodoro(isAtWorkTime: Bool)

    var title: String {
        switch self {
        case .timer:
            String(format: NSLocalizedString("extendSomething", comment: ""), String(localized: "activity"))
        case let .pomodoro(isAtWorkTime):
            String(format: NSLocalizedString("extendSomething", comment: ""), isAtWorkTime ? String(localized: "focusTime") : String(localized: "pauseTime"))
        }
    }

    var primaryButtonAction: Selector {
        switch self {
        case .timer, .pomodoro:
            #selector(FocusSessionDelegate.didExtend)
        }
    }
}

class FocusExtensionAlertView: UIView {
    // MARK: - Delegate

    weak var delegate: (any FocusSessionDelegate)?

    private let hours: [Int] = Array(0 ..< 24)
    private let minutes: [Int] = Array(0 ..< 60)
    var selectedHours = 0
    var selectedMinutes = 5

    // MARK: - UI Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let datePicker: CustomDatePickerView = {
        let picker = CustomDatePickerView()
        picker.hoursPicker.tag = PickerCase.timerHours
        picker.minutesPicker.tag = PickerCase.timerMinutes
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var secondaryButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "cancel"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        button.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(FocusSessionDelegate.didCancelExtend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var primaryButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "continue"), cornerRadius: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        layer.cornerRadius = 24
        translatesAutoresizingMaskIntoConstraints = false
        configurePicker()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with extendTimerCase: FocusExtensionAlertCase, atSuperview superview: UIView) {
        titleLabel.text = extendTimerCase.title
        setPrimaryButton(with: extendTimerCase)
        setupUI()
        layoutToSuperview(superview)
    }

    private func setPrimaryButton(with extendTimerCase: FocusExtensionAlertCase) {
        primaryButton.addTarget(delegate, action: extendTimerCase.primaryButtonAction, for: .touchUpInside)
    }

    private func configurePicker() {
        let subviews = datePicker.subviews
        let subpickers = subviews.compactMap { $0 as? UIPickerView }
        for subpicker in subpickers {
            subpicker.dataSource = self
            subpicker.delegate = self
        }

        datePicker.hoursPicker.selectRow(selectedHours, inComponent: 0, animated: false)
        datePicker.minutesPicker.selectRow(selectedMinutes, inComponent: 0, animated: false)
    }
}

// MARK: - UI Setup

extension FocusExtensionAlertView: ViewCodeProtocol {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(datePicker)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),

            datePicker.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 169 / 366),
            datePicker.heightAnchor.constraint(equalTo: datePicker.widthAnchor, multiplier: 140 / 169),
            datePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
        ])
    }

    private func layoutToSuperview(_ superview: UIView) {
        removeFromSuperview()

        superview.addSubview(self)
        addSubview(secondaryButton)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 366 / 390),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 318 / 366),

            secondaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 160 / 366),
            secondaryButton.heightAnchor.constraint(equalTo: secondaryButton.widthAnchor, multiplier: 55 / 160),
            secondaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),

            primaryButton.widthAnchor.constraint(equalTo: secondaryButton.widthAnchor),
            primaryButton.heightAnchor.constraint(equalTo: secondaryButton.heightAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: secondaryButton.trailingAnchor, constant: 12),
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.bottomAnchor),
        ])
    }
}

extension FocusExtensionAlertView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        switch pickerView.tag {
        case PickerCase.timerHours:
            hours.count
        case PickerCase.timerMinutes:
            minutes.count
        default:
            0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent _: Int, reusing _: UIView?) -> UIView {
        var selection = 0

        switch pickerView.tag {
        case PickerCase.timerHours:
            selection = hours[row]
        case PickerCase.timerMinutes:
            selection = minutes[row]
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
            selectedHours = hours[row]
        case PickerCase.timerMinutes:
            selectedMinutes = minutes[row]
        default:
            break
        }

        changePrimaryButtonState()
        pickerView.reloadAllComponents()
    }

    func pickerView(_: UIPickerView, rowHeightForComponent _: Int) -> CGFloat {
        30
    }

    private func changePrimaryButtonState() {
        let isEnabled = selectedHours != 0 || selectedMinutes != 0
        primaryButton.isEnabled = isEnabled
        primaryButton.backgroundColor = isEnabled ? .label : .systemGray4
    }
}
