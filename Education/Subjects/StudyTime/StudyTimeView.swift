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
    
    private let navigationBar: NavigationBarComponent = {
        let navigationBar = NavigationBarComponent()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    let viewModeControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl()

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let semiboldFont: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: semiboldFont,
        ]
        let titleAttributesUnselected: [NSAttributedString.Key: Any] = [
            .font: regularFont,
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
    
    func setNavigationBar() {
        let title = String(localized: "subjectTab")
        let buttonImage = UIImage(systemName: "plus.circle.fill")
        navigationBar.configure(titleText: title, rightButtonImage: buttonImage)
        navigationBar.addRightButtonTarget(delegate, action: #selector(StudyTimeDelegate.plusButtonTapped))
    }
}

// MARK: - UI Setup

extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        addSubview(navigationBar)
        navigationBar.layoutToSuperview()
        addSubview(viewModeControl)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            viewModeControl.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
            viewModeControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            viewModeControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            tableView.topAnchor.constraint(equalTo: viewModeControl.bottomAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
}
