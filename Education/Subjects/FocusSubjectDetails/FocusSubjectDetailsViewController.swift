//
//  FocusSubjectDetailsViewController.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//

import Foundation
import UIKit

class FocusSubjectDetailsViewController: UIViewController {
    weak var coordinator: Dismissing?
    let viewModel: FocusSubjectDetailsViewModel
    
    lazy var focusSubjectDetails: FocusSubjectDetailsView = {
        let view = FocusSubjectDetailsView()
        view.delegate =  self
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        return view
    }()
    
    // MARK: - Initializer

    init(viewModel: FocusSubjectDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        view = focusSubjectDetails
        viewModel.getDateString()
        viewModel.getHourString()
    }
}

// MARK: - TableView Data Source and Delegate

extension FocusSubjectDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        3
    }
    
    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var text = String()

        switch section {
        case 0:
            text = String(localized: "testDate")
        case 1:
            text = String(localized: "hour")
        case 2:
            text = String(localized: "timer")
        default:
            text = String()
        }
        
        let contentView = UIView()

        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)

        var text = String()
        switch section {
        case 0:
            text = viewModel.dateString
        case 1:
            text = viewModel.hoursString
        case 2:
            text = viewModel.focusSession.unwrappedTimerCase.text
        default:
            text = String()
        }

        cell.selectionStyle = .none
        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.textLabel?.textColor = .systemText
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
    
    
}
