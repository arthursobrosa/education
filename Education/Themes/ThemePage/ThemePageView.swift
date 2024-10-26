//
//  ThemePageView.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import SwiftUI
import UIKit

class ThemePageView: UIView {
    // MARK: - Delegate

    weak var delegate: ThemePageDelegate? {
        didSet {
            delegate?.setSegmentedControl(segmentedControl)
        }
    }

    // MARK: - UI Components

    let segmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl()

        let fontRegular = UIFont(name: Fonts.darkModeOnRegular, size: 13)
        let fontBold = UIFont(name: Fonts.darkModeOnSemiBold, size: 13)

        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: fontRegular ?? UIFont.systemFont(ofSize: 13),
        ]
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)

        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: fontBold ?? UIFont.systemFont(ofSize: 13),
        ]
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)

        control.translatesAutoresizingMaskIntoConstraints = false

        return control
    }()

    var customChart: CustomChart? {
        didSet {
            setupUI()
        }
    }

    let stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let dayLabel = UILabel()
        dayLabel.text = String(localized: "dayLabel")
        dayLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        dayLabel.textColor = .systemText50

        let questionsLabel = UILabel()
        questionsLabel.text = String(localized: "questionLabel")
        questionsLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        questionsLabel.textColor = .systemText50

        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(questionsLabel)

        return stackView
    }()

    var tableView: CustomTableView?

    let emptyView: NoThemesView = {
        let view = NoThemesView()
        view.noThemesCase = .test

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension ThemePageView: ViewCodeProtocol {
    func setupUI() {
        guard let customChart,
              let tableView else { return }

        customChart.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(segmentedControl)
        addSubview(customChart)
        addSubview(tableView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            customChart.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            customChart.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            customChart.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            customChart.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 260 / 844),

            stackView.topAnchor.constraint(equalTo: customChart.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),

            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
