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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFocusSessions()
    }
    
    // MARK: - Methods
    
    private func setNavigationItems() {
        navigationItem.title = (viewModel.subject != nil) ? viewModel.subject?.unwrappedName : String(localized: "other")
        
        let editButton = UIButton()
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.setPreferredSymbolConfiguration(.init(pointSize: 22), forImageIn: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        editButton.tintColor = UIColor(named: "system-text")
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.setPreferredSymbolConfiguration(.init(pointSize: 22), forImageIn: .normal)
        deleteButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.tintColor = UIColor(named: "system-text")
        
        let addItem = UIBarButtonItem(customView: editButton)
        let deleteItem = UIBarButtonItem(customView: deleteButton)
        
        if viewModel.subject != nil {
            navigationItem.rightBarButtonItems = [addItem]
        } else {
            navigationItem.rightBarButtonItems = [deleteItem]
        }
    }
    
    @objc
    private func listButtonTapped() {
        coordinator?.showSubjectCreation(viewModel: viewModel.studyTimeViewModel)
    }
    
    @objc
    private func deleteButtonTapped() {
        showDeleteOtherAlert()
    }
    
    private func showDeleteOtherAlert() {
        let alert = UIAlertController(title: String(localized: "deleteOther"), message: String(localized: "deleteOtherBodyText"), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: String(localized: "confirm"), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.deleteOtherSessions()
            self.viewModel.fetchFocusSessions()
            self.subjectDetailsView.tableView.reloadData()
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
        
        let months = Array(viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[indexPath.section]
        if let session = viewModel.sessionsByMonth[monthKey]?[indexPath.row] {
            cell.configure(with: session, color: viewModel.subject?.unwrappedColor ?? "button-normal")
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
