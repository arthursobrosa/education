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
    let viewModeSelector: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnSemiBold, size: 13)!
        ]
        segmentedControl.setTitleTextAttributes(titleAttributes, for: .normal)
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
    
    var emptyView = EmptyView(message: String(localized: "emptyDaySchedule"))
    
    lazy var noSubjectsView: NoSubjectsView = {
        let view = NoSubjectsView()
       
        view.setButtonTarget(target: self, action: #selector(emptyViewButtonTapped))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
   }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        view.alpha = 0
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var createAcitivityButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle(String(localized: "createActivity"), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.alpha = 0
        
        button.addTarget(self, action: #selector(createActivityButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var startActivityButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle(String(localized: "imediateActivity"), for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        button.layer.cornerRadius = 20
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
        let message = isDaily ? String(localized: "emptyDaySchedule") : String(localized: "emptyWeekSchedule")
        
        self.emptyView = EmptyView(message: message)
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
            viewModeSelector.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            viewModeSelector.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            
            contentView.topAnchor.constraint(equalTo: viewModeSelector.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            createAcitivityButton.topAnchor.constraint(equalTo: overlayView.topAnchor),
            createAcitivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            createAcitivityButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.045),
            
            startActivityButton.topAnchor.constraint(equalTo: createAcitivityButton.bottomAnchor, constant: btnPadding),
            startActivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            startActivityButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.045)
        ])
    }
}
