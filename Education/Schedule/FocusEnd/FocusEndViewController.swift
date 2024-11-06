//
//  FocusEndViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import UIKit

class FocusEndViewController: UIViewController {
    // MARK: - Coordinator & ViewModel

    weak var coordinator: Dismissing?
    let viewModel: FocusEndViewModel

    // MARK: - Properties

    private lazy var focusEndView: FocusEndView = {
        let view = FocusEndView()
        view.delegate = self
        view.activityTableView.dataSource = self
        view.activityTableView.delegate = self
        view.activityTableView.register(FocusEndSubjectCell.self, forCellReuseIdentifier: FocusEndSubjectCell.identifier)
        view.activityTableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        view.activityTableView.register(NotesCell.self, forCellReuseIdentifier: NotesCell.identifier)
        return view
    }()

    // MARK: - Initializer

    init(viewModel: FocusEndViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = focusEndView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSubjectNames()
    }
    
    // MARK: - Methods
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.focusEndView.activityTableView.reloadData()
        }
    }
}

// MARK: - TableView Data Source and Delegate

extension FocusEndViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        5
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var text = String()

        switch section {
        case 0:
            text = String(localized: "subject")
        case 1:
            text = String(localized: "testDate")
        case 2:
            text = String(localized: "hour")
        case 3:
            text = String(localized: "timer")
        case 4:
            text = String(localized: "notes")
        default:
            text = String()
        }
        
        let contentView = UIView()

        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .label.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        return contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        
        if section == 0 {
            return tableView.bounds.height * (50 / 542)
        }

        if section == 4 {
            return tableView.bounds.height * (229 / 542)
        }

        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FocusEndSubjectCell.identifier, for: indexPath) as? FocusEndSubjectCell else {
                fatalError("Could not dequeue bordered cell")
            }
            
            cell.selectionStyle = .none
            cell.title = viewModel.selectedSubjectInfo.name
            
            return cell
        }

        if section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesCell.identifier, for: indexPath) as? NotesCell else { fatalError("Could not dequeue notes cell")
            }

            cell.selectionStyle = .none
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)

        var text = String()
        switch section {
        case 1:
            text = viewModel.dateString
        case 2:
            text = viewModel.hoursString
        case 3:
            text = viewModel.timerModeString
        default:
            text = String()
        }

        cell.selectionStyle = .none
        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.textLabel?.textColor = .label
        cell.textLabel?.textAlignment = .left

        guard let textLabel = cell.textLabel else { return cell }

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(textLabel.constraints)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 4),
            textLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        
        if let popover = createSubjectsPopover(forTableView: tableView, at: indexPath) {
            present(popover, animated: true)
        }
    }
}
