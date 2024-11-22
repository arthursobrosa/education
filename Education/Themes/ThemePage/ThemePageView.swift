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
    
    private let navigationBar: NavigationBarComponent = {
        let navigationBar = NavigationBarComponent()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
            setupContentView()
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

    var tableView: BorderedTableView?

    let emptyView: NoThemesView = {
        let view = NoThemesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setNavigationBar(with title: String) {
        let buttonImage = UIImage(systemName: "plus.circle.fill")
        navigationBar.configure(titleText: title, rightButtonImage: buttonImage, hasBackButton: true)
        navigationBar.addRightButtonTarget(delegate, action: #selector(ThemePageDelegate.addTestButtonTapped))
        navigationBar.addBackButtonTarget(delegate, action: #selector(ThemePageDelegate.didTapBackButton))
    }
}

// MARK: - UI Setup

extension ThemePageView: ViewCodeProtocol {
    func setupUI() {
        addSubview(navigationBar)
        navigationBar.layoutToSuperview()
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 13),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setupContentView() {
        guard let customChart,
              let tableView else { return }

        customChart.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(segmentedControl)
        contentView.addSubview(customChart)
        contentView.addSubview(tableView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            customChart.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 18),
            customChart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            customChart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            customChart.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 160 / 844),

            stackView.topAnchor.constraint(equalTo: customChart.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),

            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
