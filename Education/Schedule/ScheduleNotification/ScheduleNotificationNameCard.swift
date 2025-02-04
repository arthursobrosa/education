//
//  ScheduleNotificationNameCard.swift
//  Education
//
//  Created by Lucas Cunha on 14/08/24.
//

import UIKit

class ScheduleNotificationNameCard: UIView {
    private let subjectName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnBold, size: 21)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var dayLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let bracket: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal1")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: img)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private let startTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 20)

        lbl.translatesAutoresizingMaskIntoConstraints = false

        return lbl
    }()

    private let lineStartTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: img)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private let endTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnMedium, size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let lineEndTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: img)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    init(startTime: String, endTime: String, subjectName: String, dayOfWeek: String, color: UIColor) {
        super.init(frame: .zero)

        self.subjectName.text = subjectName
        self.subjectName.textColor = color.darker(by: 0.6)

        setDayLabel(withColor: color, and: dayOfWeek)

        bracket.tintColor = color.darker(by: 0.6)

        self.startTime.text = startTime
        self.startTime.textColor = color.darker(by: 0.8)

        lineStartTime.tintColor = color.darker(by: 0.6)

        self.endTime.text = endTime
        self.endTime.textColor = color

        lineEndTime.tintColor = color.darker(by: 0.6)

        backgroundColor = color.withAlphaComponent(0.2)

        setupUI()

        layer.cornerRadius = 14
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDayLabel(withColor color: UIColor, and dayOfWeek: String) {
        let attributedString = NSMutableAttributedString()

        let darkerColor = color.darker(by: 0.8) ?? .label

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(darkerColor)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 20, height: 20)
        let imageString = NSAttributedString(attachment: imageAttachment)

        let mediumFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        let dayString = NSAttributedString(string: dayOfWeek, attributes: [.font: mediumFont, .foregroundColor: darkerColor, .baselineOffset: 2])

        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(dayString)

        dayLabel.attributedText = attributedString
    }
}

extension ScheduleNotificationNameCard: ViewCodeProtocol {
    func setupUI() {
        addSubview(subjectName)
        addSubview(dayLabel)
        addSubview(bracket)
        addSubview(startTime)
        addSubview(lineStartTime)
        addSubview(endTime)
        addSubview(lineEndTime)

        NSLayoutConstraint.activate([
            subjectName.topAnchor.constraint(equalTo: topAnchor, constant: 28),
            subjectName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            subjectName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),

            dayLabel.leadingAnchor.constraint(equalTo: subjectName.leadingAnchor),
            dayLabel.topAnchor.constraint(equalTo: subjectName.bottomAnchor, constant: 16),

            bracket.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 53 / 220),
            bracket.widthAnchor.constraint(equalTo: bracket.heightAnchor, multiplier: 6 / 53),
            bracket.leadingAnchor.constraint(equalTo: subjectName.leadingAnchor),
            bracket.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 42),

            startTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 10),
            startTime.centerYAnchor.constraint(equalTo: bracket.topAnchor),

            lineStartTime.centerYAnchor.constraint(equalTo: startTime.centerYAnchor),
            lineStartTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 10),

            endTime.leadingAnchor.constraint(equalTo: startTime.leadingAnchor),
            endTime.centerYAnchor.constraint(equalTo: bracket.bottomAnchor),

            lineEndTime.centerYAnchor.constraint(equalTo: endTime.centerYAnchor),
            lineEndTime.leadingAnchor.constraint(equalTo: lineStartTime.leadingAnchor),
        ])
    }
}
