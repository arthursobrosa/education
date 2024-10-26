//
//  ScheduleView.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleView: UIView {
    // MARK: - Delegate

    weak var delegate: ScheduleDelegate? {
        didSet {
            delegate?.setSegmentedControl(scheduleModeSelector)
        }
    }

    // MARK: - UI Components

    let scheduleModeSelector: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl()

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: UIFont(name: Fonts.darkModeOnSemiBold, size: 13)!,
        ]
        let titleAttributesUnselected: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: UIFont(name: Fonts.darkModeOnRegular, size: 13)!,
        ]
        segmentedControl.setTitleTextAttributes(titleAttributesUnselected, for: .normal)
        segmentedControl.setTitleTextAttributes(titleAttributes, for: .selected)

        return segmentedControl
    }()

    let contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let dailyScheduleView = DailyScheduleView()
    let weeklyScheduleCollection = WeeklyScheduleCollectionView()

    var noSchedulesView: NoSchedulesView = {
        let view = NoSchedulesView()
        view.noSchedulesCase = .day

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let noSubjectsView: NoSubjectsView = {
        let view = NoSubjectsView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let fourDotsView: FourDotsView = {
        let view = FourDotsView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var createAcitivityButton: UIButton = {
        let button = ButtonComponent(
            insets: NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            title: String(localized: "createActivity"),
            fontStyle: Fonts.darkModeOnMedium,
            fontSize: 17,
            cornerRadius: 25
        )
        button.tintColor = .label
        button.layer.masksToBounds = true
        button.alpha = 0

        button.addTarget(delegate, action: #selector(ScheduleDelegate.createActivityButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var startActivityButton: ButtonComponent = {
        let button = ButtonComponent(
            insets: NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            title: String(localized: "immediateActivity"),
            fontStyle: Fonts.darkModeOnMedium,
            fontSize: 17,
            cornerRadius: 25
        )
        button.tintColor = .label
        button.layer.masksToBounds = true
        button.alpha = 0

        button.addTarget(delegate, action: #selector(ScheduleDelegate.startActivityButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func changeNoSchedulesView(isDaily: Bool) {
        noSchedulesView.noSchedulesCase = isDaily ? .day : .week
    }
}

// MARK: - UI Setup

extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        addSubview(scheduleModeSelector)
        addSubview(contentView)

        let padding = 10.0

        NSLayoutConstraint.activate([
            scheduleModeSelector.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            scheduleModeSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            scheduleModeSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            contentView.topAnchor.constraint(equalTo: scheduleModeSelector.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        overlayView.addSubview(fourDotsView)
        overlayView.addSubview(createAcitivityButton)
        overlayView.addSubview(startActivityButton)

        NSLayoutConstraint.activate([
            fourDotsView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: -50),
            fourDotsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            fourDotsView.widthAnchor.constraint(equalToConstant: 50),
            fourDotsView.heightAnchor.constraint(equalToConstant: 50),

            createAcitivityButton.topAnchor.constraint(equalTo: fourDotsView.bottomAnchor, constant: padding),
            createAcitivityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(padding * 2)),

            startActivityButton.topAnchor.constraint(equalTo: createAcitivityButton.bottomAnchor, constant: padding),
            startActivityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(padding * 2)),
        ])
    }
}
