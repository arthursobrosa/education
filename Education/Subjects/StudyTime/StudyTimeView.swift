//
//  StudyTimeView.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import SwiftUI
import UIKit

class StudyTimeView: UIView {
    // MARK: - Delegate

    weak var delegate: StudyTimeDelegate? {
        didSet {
            delegate?.setSegmentedControl(viewModeControl)
        }
    }

    // MARK: - UI Components

    let viewModeControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl()

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnSemiBold, size: 13)!,
        ]
        let titleAttributesUnselected: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnRegular, size: 13)!,
        ]
        segmentedControl.setTitleTextAttributes(titleAttributesUnselected, for: .normal)
        segmentedControl.setTitleTextAttributes(titleAttributes, for: .selected)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        return segmentedControl
    }()

    let chartView: StudyTimeChartView

    lazy var chartController: UIHostingController<StudyTimeChartView> = {
        let controller = UIHostingController(rootView: self.chartView)

        controller.view.translatesAutoresizingMaskIntoConstraints = false

        return controller
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderTopPadding = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    // MARK: - Initialization

    init(chartView: StudyTimeChartView) {
        self.chartView = chartView

        super.init(frame: .zero)

        backgroundColor = .systemBackground

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func darkModeSegmentedControl() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            viewModeControl.backgroundColor = .white.withAlphaComponent(10)
        default:
            viewModeControl.backgroundColor = .black.withAlphaComponent(40)
        }
    }
}

// MARK: - UI Setup

extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        addSubview(viewModeControl)
        addSubview(tableView)

        let padding = 10.0

        NSLayoutConstraint.activate([
            viewModeControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            viewModeControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            viewModeControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            tableView.topAnchor.constraint(equalTo: viewModeControl.bottomAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
}
