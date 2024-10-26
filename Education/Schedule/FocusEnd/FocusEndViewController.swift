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

    private lazy var focusView: FocusEndView = {
        let view = FocusEndView()
        view.delegate = self
        view.activityTableView.dataSource = self
        view.activityTableView.delegate = self
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
        super.loadView()

        view = focusView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Table View Data Source and Delegate

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

        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .label.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.text = text
        return label
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        0
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section

        if section == 4 {
            return tableView.bounds.height * (263 / 528)
        }

        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        if section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesCell.identifier, for: indexPath) as? NotesCell else { fatalError("Could not dequeue notes cell") }

            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)

        var text = String()
        switch section {
        case 0:
            text = viewModel.getSubjectString()
        case 1:
            text = viewModel.getDateString()
        case 2:
            text = viewModel.getHourString()
        case 3:
            text = viewModel.getTimerString()
        default:
            text = String()
        }

        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.textLabel?.textColor = .label
        cell.textLabel?.textAlignment = .left

        guard let textLabel = cell.textLabel else {
            return cell
        }

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(textLabel.constraints)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])

        return cell
    }
}
