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
            delegate?.setPicker(self.picker)
        }
    }
    
    weak var viewModeDelegate: ViewModeSelectorDelegate? 
    
    // MARK: - UI Components
    let picker: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 4
        
        stack.backgroundColor = .systemBackground
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
     let viewModeSelector: UISegmentedControl = {
          let segmentedControl = UISegmentedControl(items: [String(localized: "daily"), String(localized: "weekly")])
          segmentedControl.selectedSegmentIndex = 0
          segmentedControl.translatesAutoresizingMaskIntoConstraints = false
          segmentedControl.backgroundColor = .black
          segmentedControl.selectedSegmentTintColor = .gray
          segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
          segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
          return segmentedControl
      }()
    
    let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none

        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let collectionViews: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isHidden = true
        return collection
    }()
    
    let emptyView = EmptyView(object: String(localized: "emptySchedule"))
    
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
        
        viewModeSelector.addTarget(self, action: #selector(viewModeChanged(_:)), for: .valueChanged)
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
    
    @objc private func viewModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewModeDelegate?.didSelectDailyModeToday()
        case 1:
            self.viewModeDelegate?.didSelectWeeklyMode()
        default:
            break
        }
    }
}

// MARK: - UI Setup
extension ScheduleView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(viewModeSelector)
        self.addSubview(picker)
        self.addSubview(contentView)
        self.addSubview(overlayView)
        overlayView.addSubview(createAcitivityButton)
        overlayView.addSubview(startActivityButton)
        
        let btnPadding = 10.0
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            
            viewModeSelector.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            viewModeSelector.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viewModeSelector.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            picker.topAnchor.constraint(equalTo: self.viewModeSelector.bottomAnchor, constant: padding),
            picker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
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
            createAcitivityButton.heightAnchor.constraint(equalToConstant: 40),
            
            startActivityButton.topAnchor.constraint(equalTo: createAcitivityButton.bottomAnchor, constant: btnPadding),
            startActivityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -btnPadding),
            startActivityButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
