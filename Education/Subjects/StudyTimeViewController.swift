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
    private lazy var studyTimeView: StudyTimeView = {
        let studyTimeChartView = StudyTimeChartView(viewModel: self.viewModel)
        
        let view = StudyTimeView(chartView: studyTimeChartView)
        
        view.delegate = self
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(SubjectTimeTableViewCell.self, forCellReuseIdentifier: SubjectTimeTableViewCell.identifier)
        
        return view
    }()
    
    
    // MARK: - Initialization
    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.studyTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            self.studyTimeView.changeEmptyView(emptySubject: subjects.isEmpty)
            
            self.reloadTable()
        }
        
        self.viewModel.focusSessions.bind { [weak self] focusSessions in
            guard let self else { return }
            
            self.setContentView(isEmpty: focusSessions.isEmpty)
            
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
    func reloadTable() {
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
        return self.viewModel.subjects.value.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        var subject: Subject? = nil
        
        subject = row <= (self.viewModel.subjects.value.count - 1) ? self.viewModel.subjects.value[indexPath.row] : nil
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension StudyTimeViewController {
    func setContentView(isEmpty: Bool) {
        self.studyTimeView.removeConstraints(self.studyTimeView.emptyView.constraints)
        self.studyTimeView.removeConstraints(self.studyTimeView.chartController.view.constraints)
        
        self.addContentSubview(isEmpty ? self.studyTimeView.emptyView : self.studyTimeView.chartController.view)
    }
    
    private func addContentSubview(_ subview: UIView) {
        self.studyTimeView.contentView.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.studyTimeView.contentView.topAnchor),
            subview.leadingAnchor.constraint(equalTo: self.studyTimeView.contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.studyTimeView.contentView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: self.studyTimeView.contentView.bottomAnchor)
        ])
    }
}
