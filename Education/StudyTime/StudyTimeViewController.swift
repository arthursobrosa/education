//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeViewController: UIViewController{
    // MARK: - Properties

    private var subjects = [Subject]()
    private var viewModel: StudyTimeViewModel!
    private lazy var studyTimeView: StudyTimeView = {
        let vw = StudyTimeView(viewModel: self.viewModel)
        
        vw.studyTimeTableView.delegate = self
        vw.studyTimeTableView.dataSource = self
        vw.studyTimeTableView.register(SubjectTimeTableViewCell.self, forCellReuseIdentifier: SubjectTimeTableViewCell.identifier)
        return vw
    }()
    
    // MARK: - Initialization
    
    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.studyTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self = self else { return }
            
            self.subjects = subjects
            self.studyTimeView.reloadTable()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSubjects()
    }
}

// MARK: - UITableViewDataSource
extension StudyTimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = self.subjects[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTimeTableViewCell.identifier, for: indexPath) as? SubjectTimeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.subject = subject
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let subject = self.subjects[indexPath.row]
        
        if editingStyle == .delete {
            self.viewModel.removeSubject(subject: subject)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension StudyTimeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.subjects[indexPath.row]
    }

}


