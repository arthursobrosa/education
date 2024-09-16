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
            delegate?.setSegmentedControl(self.viewModeSelector)
        }
    }
    
    // MARK: - UI Components
    let viewModeSelector: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnSemiBold, size: 13)!
        ]
        let titleAttributesUnselected: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnRegular, size: 13)!
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
    
    var emptyView: NoSchedulesView = {
        let view = NoSchedulesView()
        view.noSchedulesCase = .day
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var noSubjectsView: NoSubjectsView = {
        let view = NoSubjectsView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
   }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var createAcitivityButton: UIButton = {
        let button = ButtonComponent(
            insets: NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            title: String(localized: "createActivity"),
            fontStyle: Fonts.darkModeOnMedium,
            fontSize: 16,
            cornerRadius: 25
        )
        button.tintColor = .label
        button.layer.masksToBounds = true
        button.alpha = 0
        
        button.addTarget(self, action: #selector(createActivityButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var startActivityButton: ButtonComponent = {
        let button = ButtonComponent(
            insets: NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24),
            title: String(localized: "imediateActivity"),
            fontStyle: Fonts.darkModeOnMedium,
            fontSize: 16,
            cornerRadius: 25
        )
        button.tintColor = .label
        button.layer.masksToBounds = true
        button.alpha = 0
        
        button.addTarget(self, action: #selector(startActivityTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func createActivityButtonTapped() {
        self.delegate?.createAcitivityTapped()
    }
    
    @objc private func startActivityTapped() {
        self.delegate?.startAcitivityTapped()
    }
    
    @objc private func emptyViewButtonTapped() {
        self.delegate?.emptyViewButtonTapped()
    }
    
    func changeEmptyView(isDaily: Bool) {
        self.emptyView.noSchedulesCase = isDaily ? .day : .week
    }
}

// MARK: - UI Setup
extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(viewModeSelector)
        self.addSubview(contentView)
        self.addSubview(overlayView)
        overlayView.addSubview(createAcitivityButton)
        overlayView.addSubview(startActivityButton)
        
        let btnPadding = 10.0
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            viewModeSelector.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            viewModeSelector.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            viewModeSelector.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            contentView.topAnchor.constraint(equalTo: viewModeSelector.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            createAcitivityButton.topAnchor.constraint(equalTo: overlayView.topAnchor),
            createAcitivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            startActivityButton.topAnchor.constraint(equalTo: createAcitivityButton.bottomAnchor, constant: btnPadding),
            startActivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
}
