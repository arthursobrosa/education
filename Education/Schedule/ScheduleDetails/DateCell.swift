//
//  DateCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 08/11/24.
//

import UIKit

enum DateCellRow: CaseIterable {
    case dayOfWeek
    case startDate
    case endDate
    
    var title: String {
        switch self {
        case .dayOfWeek:
            String(localized: "dayOfWeek")
        case .startDate:
            String(localized: "startDate")
        case .endDate:
            String(localized: "endDate")
        }
    }
}

class DateCell: UITableViewCell {
    // MARK: ID
    static let identifier = "dateCell"
    
    // MARK: - Delegate to connect with VC
    weak var delegate: ScheduleDetailsDelegate?
    
    // MARK: - Properties
    
    var dayOfWeekTitle: String? {
        didSet {
            guard let dayOfWeekTitle else { return }
            
            var labelText = dayOfWeekTitle
            let maxLength = 22

            if dayOfWeekTitle.count > maxLength {
                labelText = String(dayOfWeekTitle.prefix(maxLength)) + "..."
            }

            dayOfWeekLabel.text = labelText
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var dayOfWeekTitleLabel: UILabel = createLabel(for: .dayOfWeek)
    private lazy var startDateLabel: UILabel = createLabel(for: .startDate)
    private lazy var endDateLabel: UILabel = createLabel(for: .endDate)
    
    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = UIColor.systemText50
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var startDatePicker: FakeDatePicker = createDatePicker(tag: 1)
    lazy var endDatePicker: FakeDatePicker = createDatePicker(tag: 2)
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func createLabel(for rowCase: DateCellRow) -> UILabel {
        let label = UILabel()
        label.text = rowCase.title
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createSeparators() -> [UIView] {
        var separators: [UIView] = []
        
        for _ in 0..<2 {
            let view = UIView()
            view.backgroundColor = UIColor.buttonNormal
            view.translatesAutoresizingMaskIntoConstraints = false
            separators.append(view)
        }
        
        return separators
    }
    
    private func createDatePicker(tag: Int) -> FakeDatePicker {
        let datePicker = FakeDatePicker()
        datePicker.datePickerMode = .time
        datePicker.addTarget(delegate, action: #selector(ScheduleDetailsDelegate.datePickerEditionBegan(_:)), for: .editingDidBegin)
        datePicker.addTarget(delegate, action: #selector(ScheduleDetailsDelegate.datePickerEditionEnded(_:)), for: .editingDidEnd)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }
}

// MARK: - UI Setup

extension DateCell: ViewCodeProtocol {
    func setupUI() {
        layer.cornerRadius = 17
        layer.borderWidth = 1
        layer.borderColor = UIColor.buttonNormal.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        let separators = createSeparators()
        
        contentView.addSubview(dayOfWeekTitleLabel)
        contentView.addSubview(dayOfWeekLabel)
        contentView.addSubview(separators[0])
        contentView.addSubview(startDateLabel)
        contentView.addSubview(startDatePicker)
        contentView.addSubview(separators[1])
        contentView.addSubview(endDateLabel)
        contentView.addSubview(endDatePicker)
        
        NSLayoutConstraint.activate([
            dayOfWeekTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            dayOfWeekTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            
            dayOfWeekLabel.topAnchor.constraint(equalTo: dayOfWeekTitleLabel.topAnchor),
            dayOfWeekLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            
            separators[0].topAnchor.constraint(equalTo: dayOfWeekTitleLabel.bottomAnchor, constant: 14),
            separators[0].heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 150),
            separators[0].widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 349 / 366),
            separators[0].trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            startDateLabel.topAnchor.constraint(equalTo: separators[0].bottomAnchor, constant: 14),
            startDateLabel.leadingAnchor.constraint(equalTo: dayOfWeekTitleLabel.leadingAnchor),
            
            startDatePicker.topAnchor.constraint(equalTo: separators[0].bottomAnchor, constant: 8),
            startDatePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            separators[1].topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 14),
            separators[1].heightAnchor.constraint(equalTo: separators[0].heightAnchor),
            separators[1].widthAnchor.constraint(equalTo: separators[0].widthAnchor),
            separators[1].trailingAnchor.constraint(equalTo: separators[0].trailingAnchor),
            
            endDateLabel.topAnchor.constraint(equalTo: separators[1].bottomAnchor, constant: 14),
            endDateLabel.leadingAnchor.constraint(equalTo: startDateLabel.leadingAnchor),
            
            endDatePicker.topAnchor.constraint(equalTo: separators[1].bottomAnchor, constant: 8),
            endDatePicker.trailingAnchor.constraint(equalTo: startDatePicker.trailingAnchor),
        ])
    }
}
