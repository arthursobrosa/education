//
//  SubjectDetailsViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import Foundation
import UIKit

class SubjectDetailsViewController: UIViewController{
   
    
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (Dismissing & ShowingFocusSubjectDetails)?
    let viewModel: SubjectDetailsViewModel

    // MARK: - Properties

    private lazy var subjectDetailsView: SubjectDetailsView = {
        let view = SubjectDetailsView()
        view.delegate = self

        view.tableView.register(FocusSessionCell.self, forCellReuseIdentifier: FocusSessionCell.identifier)
        view.tableView.delegate = self
        view.tableView.dataSource = self

        return view
    }()

    // MARK: - Initialization

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

        setupNavigationItems()
        self.viewModel.fetchFocusSessions()
    }

    // MARK: - Methods

    private func setupNavigationItems() {
        
        navigationItem.title = self.viewModel.subject.unwrappedName
        
    }
    
    func formatMonthYear(monthYear: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        
        // Converte a string para uma data
        guard let date = dateFormatter.date(from: monthYear) else {
            return nil
        }
        
        // Define o formato de acordo com o idioma atual
        var formattedDate: String
        if Locale.current.languageCode == "pt" {
            dateFormatter.dateFormat = "LLLL 'de' yyyy"  // Exemplo: "Setembro de 2024"
            formattedDate = dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "LLLL yyyy"  // Exemplo: "September 2024"
            formattedDate = dateFormatter.string(from: date)
        }
        
        // Garante que a primeira letra do mês seja maiúscula
        return formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()
    }
}

protocol SubjectDetailsDelegate: AnyObject {
    func substituirDepois()
}

extension SubjectDetailsViewController: SubjectDetailsDelegate {
    func substituirDepois(){
        
    }
}

extension SubjectDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sessionsByMonth.keys.count
        }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let months = Array(self.viewModel.sessionsByMonth.keys).sorted(by: >)
        return formatMonthYear(monthYear: months[section]) 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let months = Array(self.viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[section]
        return self.viewModel.sessionsByMonth[monthKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FocusSessionCell.identifier, for: indexPath) as! FocusSessionCell
        
        let months = Array(self.viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[indexPath.section]
        if let session = self.viewModel.sessionsByMonth[monthKey]?[indexPath.row] {
            cell.configure(with: session, color: self.viewModel.subject.unwrappedColor)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let months = Array(self.viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[indexPath.section]
        
        if let session = self.viewModel.sessionsByMonth[monthKey]?[indexPath.row] {
            coordinator?.showFocusSubjectDetails(focusSession: session)
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let months = Array(self.viewModel.sessionsByMonth.keys).sorted(by: >)
        let monthKey = months[section]
        let title = formatMonthYear(monthYear: monthKey)
        
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
        let totalSections = self.viewModel.sessionsByMonth.keys.count
        return section == totalSections - 1 ? 100 : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 50 : 40
    }
    
    
}
