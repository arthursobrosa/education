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
            setContentView()
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
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subjectsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OnboardingSubjectCell.self, forCellReuseIdentifier: OnboardingSubjectCell.identifer)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyView: UILabel = {
        let label = UILabel()
        label.text = String(localized: "subjectsEmpty")
        label.textColor = .systemText40
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .init(name: Fonts.darkModeOnItalic, size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    // MARK: - Methods
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.subjectsTableView.reloadData()
        }
    }
}

// MARK: - UI Setup

extension Onboarding4View {
    private func layoutContent() {
        addSubview(successLabel)
        addSubview(contentView)
        addSubview(readyLabel)
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: topAnchor, constant: 195),
            successLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            contentView.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 74),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: readyLabel.topAnchor, constant: -50),
            
            readyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -184),
            readyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            readyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
        ])
    }
    
    private func setContentView() {
        let isEmpty = subjects.isEmpty
        
        contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        if isEmpty {
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(emptyView)
            
            NSLayoutConstraint.activate([
                emptyView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        } else {
            subjectsTableView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subjectsTableView)
            
            NSLayoutConstraint.activate([
                subjectsTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
                subjectsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                subjectsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                subjectsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
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
