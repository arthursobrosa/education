//
//  SubjectListController.swift
//  Education
//
//  Created by Leandro Silva on 19/08/24.
//

import UIKit

class SubjectListController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingSubjectCreation & Dismissing)?
    let viewModel: StudyTimeViewModel
    
    // MARK: - Properties
    private var subjects = [Subject]()
    
    private lazy var subjectListView: SubjectListView = {
        let view = SubjectListView()
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(SubjectListTableViewCell.self, forCellReuseIdentifier: SubjectListTableViewCell.identifier)
        
        view.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
            
            self.view = self.subjectListView
            
            self.subjects = subjects
            self.reloadTable()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSubjects()
    }
    
    
    // MARK: - Methods
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.subjects = subjects
            self.subjectListView.tableView.reloadData()
            self.subjectListView.layoutSubviews()
        }
    }
    
    @objc private func addButtonTapped() {
        self.coordinator?.showSubjectCreation(viewModel: viewModel)
    }
    
    @objc private func okButtonTapped() {
        self.coordinator?.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension SubjectListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectListTableViewCell.identifier, for: indexPath) as? SubjectListTableViewCell else {
            return UITableViewCell()
        }
        
        let subject = subjects[indexPath.row]
        cell.configure(with: subject)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let subject = self.subjects[indexPath.row]
        
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Excluir Subject", message: "Você tem certeza que deseja excluir este \(subject.unwrappedName)? Ao aceitar será excluído seu tempo de estudo e horários maracdos", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Excluir", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.removeSubject(subject: subject)
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
