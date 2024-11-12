//
//  SubjectDetailsViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import Foundation
import UIKit

class SubjectDetailsViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    
    weak var coordinator: (Dismissing & ShowingSubjectCreation)?
    let viewModel: SubjectDetailsViewModel
    
    // MARK: - Properties
    
    private lazy var subjectDetailsView: SubjectDetailsView = {
        let view = SubjectDetailsView()
        
        view.tableView.register(FocusSessionCell.self, forCellReuseIdentifier: FocusSessionCell.identifier)
        view.tableView.delegate = self
        view.tableView.dataSource = self
        
        return view
    }()
    
    // MARK: - Initializer
    
    init(viewModel: SubjectDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = subjectDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItems()
        setContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFocusSessions()
    }
    
    // MARK: - Methods
    
    func setNavigationItems() {
        subjectDetailsView.setNavigationBar(subject: viewModel.subject)
    }
    
    func setContentView() {
        let isEmpty = viewModel.areSessionsEmpty()
        
        if isEmpty {
            addContentSubview(childSubview: subjectDetailsView.emptyView)
        } else {
            addContentSubview(childSubview: subjectDetailsView.tableView)
        }
    }
    
    private func addContentSubview(childSubview: UIView) {
        let parentSubview = subjectDetailsView.contentView
        parentSubview.addSubview(childSubview)

        childSubview.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            childSubview.topAnchor.constraint(equalTo: parentSubview.topAnchor),
            childSubview.leadingAnchor.constraint(equalTo: parentSubview.leadingAnchor),
            childSubview.trailingAnchor.constraint(equalTo: parentSubview.trailingAnchor),
            childSubview.bottomAnchor.constraint(equalTo: parentSubview.bottomAnchor),
        ])
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.subjectDetailsView.tableView.reloadData()
        }
    }
    
    func showDeleteOtherAlert() {
        let alert = UIAlertController(title: String(localized: "deleteOther"), message: String(localized: "deleteOtherBodyText"), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: String(localized: "confirm"), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.deleteOtherSessions()
            self.viewModel.fetchFocusSessions()
            self.subjectDetailsView.tableView.reloadData()
            self.setContentView()
        }
        
        let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source and Delegate

extension SubjectDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sessionsByMonth.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let months = Array(viewModel.sessionsByMonth.keys).sorted(by: >)
        let formattedMonthYear = viewModel.formattedMonthYear(months[section])
        return formattedMonthYear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let months = Array(viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[section]
        return viewModel.sessionsByMonth[monthKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FocusSessionCell.identifier, for: indexPath) as? FocusSessionCell else {
            fatalError("could not dequeu focus session cell")
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        let months = Array(viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[indexPath.section]
        if let session = viewModel.sessionsByMonth[monthKey]?[indexPath.row] {
            cell.configure(with: session, color: viewModel.subject?.unwrappedColor ?? "button-normal")
            cell.hasNotes = session.hasNotes()
        }
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let months = Array(viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[section]
        let title = viewModel.formattedMonthYear(monthKey)
        
        let headerLabel = UILabel()
        headerLabel.text = title
        headerLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 13)
        headerLabel.textColor = .secondaryLabel
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4),
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let totalSections = viewModel.sessionsByMonth.keys.count
        return section == totalSections - 1 ? 100 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 50 : 40
    }
}
