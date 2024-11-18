//
//  Onboarding4View.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/11/24.
//

import UIKit

class Onboarding4View: OnboardingView {
    // MARK: - Properties
    
    var subjects: [(name: String, colorName: String)] = [] {
        didSet {
            reloadTable()
        }
    }
    
    // MARK: - UI Properties
    
    private let successLabel: UILabel = {
        let label = UILabel()
        let titleName = String(localized: "subjectsSuccess")
        let font: UIFont = .init(name: Fonts.darkModeOnRegular, size: 17) ?? .systemFont(ofSize: 17, weight: .regular)
        let color: UIColor = .label
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let attributedTitle = NSAttributedString(string: titleName, attributes: attributes)
        label.attributedText = attributedTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tableHeightConstraint: NSLayoutConstraint?
    
    private lazy var subjectsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OnboardingSubjectCell.self, forCellReuseIdentifier: OnboardingSubjectCell.identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let readyLabel: UILabel = {
        let label = UILabel()
        let titleName = String(localized: "readyToStart")
        let font: UIFont = .init(name: Fonts.darkModeOnRegular, size: 17) ?? .systemFont(ofSize: 17, weight: .regular)
        let color: UIColor = .label
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
        ]
        let attributedTitle = NSAttributedString(string: titleName, attributes: attributes)
        label.attributedText = attributedTitle
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializer
    
    init() {
        super.init(showsBackButton: true)
        changeNextButtonName()
        hideSkipButton()
        layoutContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableHeight()
    }
    
    // MARK: - Methods
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.subjectsTableView.reloadData()
        }
    }
    
    private func updateTableHeight() {
        let tableHeight = subjectsTableView.contentSize.height
        let maxHeight = bounds.height * (300 / 844)
        
        if tableHeight <= maxHeight {
            tableHeightConstraint?.constant = tableHeight
        } else {
            tableHeightConstraint?.constant = maxHeight
        }
        
        layoutIfNeeded()
    }
}

// MARK: - UI Setup

extension Onboarding4View {
    private func layoutContent() {
        addSubview(successLabel)
        addSubview(readyLabel)
        addSubview(subjectsTableView)
        
        tableHeightConstraint = subjectsTableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: topAnchor, constant: 195),
            successLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subjectsTableView.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 74),
            subjectsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subjectsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            readyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -184),
            readyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            readyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
        ])
    }
}

// MARK: - Table View Data Source and Delegate

extension Onboarding4View: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        subjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingSubjectCell.identifer, for: indexPath) as? OnboardingSubjectCell else {
            fatalError("Could not dequeue onboarding subject cell")
        }
        
        let subject = subjects[indexPath.section]
        cell.name = subject.name
        cell.color = UIColor(named: subject.colorName)

        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        11
    }
}

// MARK: - Preview

#Preview {
    Onboarding4ViewController(viewModel: OnboardingManagerViewModel())
}
