//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit
import SwiftUI

class StudyTimeViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: ShowingSubjectList?
    let viewModel: StudyTimeViewModel
    
    // MARK: - Properties
    private var subjects = [Subject]()
    
    private lazy var studyTimeView: StudyTimeView = {
        let view = StudyTimeView()
        
        view.delegate = self
        
        let studyTimeChartView = StudyTimeChartView(viewModel: self.viewModel)
        view.chartHostingController = UIHostingController(rootView: studyTimeChartView)
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(SubjectTimeTableViewCell.self, forCellReuseIdentifier: SubjectTimeTableViewCell.identifier)
        
        return view
    }()
    
    private let emptyView = EmptyView(object: String(localized: "emptyStudyTime"))
    
    // MARK: - Initialization
    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            self.subjects = subjects
            self.reloadTable()
        }
        
        self.viewModel.focusSessions.bind { [weak self] focusSessions in
            guard let self else { return }
            
            self.setView(isEmpty: focusSessions.isEmpty)
            
            self.reloadTable()
        }
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSubjects()
        self.viewModel.fetchFocusSessions()
    }
    
    // MARK: - Methods
    private func setView(isEmpty: Bool) {
        self.view = isEmpty ? self.emptyView : self.studyTimeView
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.studyTimeView.tableView.reloadData()
        }
    }
    
    @objc func addButtonTapped() {
        self.coordinator?.showSubjectList(viewModel: viewModel)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension StudyTimeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subjects.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        var subject: Subject? = nil
        
        subject = row <= (self.subjects.count - 1) ? self.subjects[indexPath.row] : nil
        let totalTime = self.viewModel.getTotalTime(forSubject: subject)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTimeTableViewCell.identifier, for: indexPath) as? SubjectTimeTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        cell.subject = subject
        cell.totalTime = totalTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
