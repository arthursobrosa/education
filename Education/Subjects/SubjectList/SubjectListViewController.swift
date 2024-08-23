//
//  SubjectListViewController.swift
//  Education
//
//  Created by Leandro Silva on 19/08/24.
//

import UIKit

class SubjectListViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingSubjectCreation & Dismissing)?
    let viewModel: StudyTimeViewModel
    
    // MARK: - Properties
    private lazy var subjectListView: SubjectListView = {
        let view = SubjectListView()
    
        view.delegate = self
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(SubjectListTableViewCell.self, forCellReuseIdentifier: SubjectListTableViewCell.identifier)
        
        return view
    }()
    
    private lazy var emptyView: EmptyListSubjectsView = {
        let view = EmptyListSubjectsView()
        view.delegate = self
        
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        let okButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(okButtonTapped))
        okButton.tintColor = .secondaryLabel
        self.navigationItem.rightBarButtonItem = okButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            handleEmptyView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSubjects()
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            self.handleEmptyView()
        }
    }
    
    
    // MARK: - Methods
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.subjectListView.tableView.reloadData()
            self.subjectListView.layoutSubviews()
        }
    }
    
    private func handleEmptyView(){
        if self.viewModel.subjects.value.isEmpty {
            self.view = self.emptyView
            print("vazio")
        } else {
            self.view = self.subjectListView
          
            self.reloadTable()
        }
    }
    
    @objc private func okButtonTapped() {
        self.coordinator?.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension SubjectListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.subjects.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectListTableViewCell.identifier, for: indexPath) as? SubjectListTableViewCell else {
            return UITableViewCell()
        }
        
        let subject = self.viewModel.subjects.value[indexPath.row]
        cell.configure(with: subject)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let subject = self.viewModel.subjects.value[indexPath.row]
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: String(localized: "deleteSubjectTitle"), message: String(format: NSLocalizedString("deleteSubjectMessage", comment: ""), subject.unwrappedName), preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: String(localized: "confirm"), style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.removeSubject(subject: subject)
            }
            let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let subject = self.viewModel.subjects.value[indexPath.row]
        
        self.viewModel.currentEditingSubject = subject
        self.viewModel.selectedSubjectColor.value = subject.unwrappedColor
        self.coordinator?.showSubjectCreation(viewModel: self.viewModel)
    }
}
