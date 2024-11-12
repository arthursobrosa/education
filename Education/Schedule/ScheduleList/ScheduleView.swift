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
    
    private let navigationBar: NavigationBarComponent = {
        let navigationBar = NavigationBarComponent()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    let scheduleModeSelector: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl()

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let semiboldFont: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: semiboldFont,
        ]
        let titleAttributesUnselected: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemText,
            .font: regularFont,
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

    lazy var noSchedulesView: NoSchedulesView = {
        let view = NoSchedulesView()
        view.period = .day
        view.delegate = delegate
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.1)
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
        button.tintColor = UIColor(named: "system-text")
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
        button.tintColor = UIColor(named: "system-text")
        button.layer.masksToBounds = true
        button.alpha = 0

        button.addTarget(delegate, action: #selector(ScheduleDelegate.startActivityButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    let deletionAlertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.layer.zPosition = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    func setNoSchedulesView(isDaily: Bool) {
        noSchedulesView.period = isDaily ? .day : .week
    }
    
    func changeAlertVisibility(isShowing: Bool) {
        if isShowing {
            setOverlayTapGesture()
        } else {
            overlayView.gestureRecognizers = nil
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }

            self.deletionAlertView.isHidden = !isShowing
            self.overlayView.alpha = isShowing ? 1 : 0
        }
    }
    
    private func setOverlayTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayViewTapped(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func overlayViewTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: overlayView)
        
        guard !deletionAlertView.frame.contains(tapLocation) else { return }
        
        changeAlertVisibility(isShowing: false)
    }
    
    func setNavigationBar() {
        let titleImage = UIImage(named: "planno")
        let buttonImage = UIImage(systemName: "plus.circle.fill")
        navigationBar.configure(titleImage: titleImage, rightButtonImage: buttonImage)
        navigationBar.addRightButtonTarget(delegate, action: #selector(ScheduleDelegate.plusButtonTapped))
    }
}

// MARK: - UI Setup

extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        addSubview(navigationBar)
        navigationBar.layoutToSuperview()
        addSubview(scheduleModeSelector)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            scheduleModeSelector.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 24),
            scheduleModeSelector.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            scheduleModeSelector.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            contentView.topAnchor.constraint(equalTo: scheduleModeSelector.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        addSubview(createAcitivityButton)
        addSubview(startActivityButton)

        NSLayoutConstraint.activate([
            createAcitivityButton.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 49),
            createAcitivityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),

            startActivityButton.topAnchor.constraint(equalTo: createAcitivityButton.bottomAnchor, constant: 9),
            startActivityButton.trailingAnchor.constraint(equalTo: createAcitivityButton.trailingAnchor),
        ])
    }
}
