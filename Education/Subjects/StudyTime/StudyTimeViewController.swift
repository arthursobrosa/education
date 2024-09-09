//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit
import SwiftUI
import TipKit

class StudyTimeViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingSubjectCreation & ShowingOtherSubject)? 
    let viewModel: StudyTimeViewModel
    
    var createSubjectTip = CreateSubjectTip()
    
    // MARK: - Properties
    private lazy var studyTimeView: StudyTimeView = {
        let studyTimeChartView = StudyTimeChartView(viewModel: self.viewModel)
        
        let view = StudyTimeView(chartView: studyTimeChartView)
        
        view.delegate = self
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(SubjectTimeTableViewCell.self, forCellReuseIdentifier: SubjectTimeTableViewCell.identifier)
        view.tableView.register(StudyTimeChartCell.self, forCellReuseIdentifier: StudyTimeChartCell.identifier)
        
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
            
            self.reloadTable()
        }
        
        self.viewModel.focusSessions.bind { [weak self] focusSessions in
            guard let self else { return }
            
            self.setContentView(isEmpty: focusSessions.isEmpty)
            
            self.reloadTable()
        }
        
        self.setNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleTip()
        
        self.viewModel.fetchSubjects()
        self.viewModel.fetchFocusSessions()
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        self.navigationItem.title = String(localized: "subjectTab")
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: Fonts.coconRegular, size: Fonts.titleSize)!, .foregroundColor : UIColor.label]
        
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 32), forImageIn: .normal)
        addButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        addButton.tintColor = .label
        
        let addItem = UIBarButtonItem(customView: addButton)
        
        self.navigationItem.rightBarButtonItems = [addItem]

    }
    
    private func handleTip(){
        Task { @MainActor in
                for await shouldDisplay in createSubjectTip.shouldDisplayUpdates {
                    if shouldDisplay {
                        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
                            let controller = TipUIPopoverViewController(createSubjectTip, sourceItem: rightBarButtonItem)
                            controller.view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
                            present(controller, animated: true)
                        }
                    } else if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                    }
                }
            }
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.studyTimeView.tableView.reloadData()
        }
    }
    
    @objc func listButtonTapped() {
        self.coordinator?.showSubjectCreation(viewModel: viewModel)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension StudyTimeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.viewModel.subjects.value.count + 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StudyTimeChartCell.identifier, for: indexPath) as! StudyTimeChartCell
            
            let chartView = StudyTimeChartView(viewModel: self.viewModel)
            
            cell.configure(with: chartView)
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            if indexPath.row >= self.viewModel.subjects.value.count + 1 {
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }
            
            let row = indexPath.row
            let isFixedElement = row == self.viewModel.subjects.value.count
            let subject: Subject? = isFixedElement ? nil : self.viewModel.subjects.value[indexPath.row]
            let totalTime = self.viewModel.getTotalTime(forSubject: subject)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTimeTableViewCell.identifier, for: indexPath) as? SubjectTimeTableViewCell else {
                fatalError("Could not dequeue cell")
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            
            cell.subject = subject
            cell.backgroundColor = .clear
            cell.subjectName.textColor = UIColor(named: subject?.unwrappedColor ?? "sealBackgroundColor")
            cell.totalHours.textColor = UIColor(named: subject?.unwrappedColor ?? "sealBackgroundColor")
            cell.totalTime = totalTime
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {return}
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SubjectTimeTableViewCell,
              let subject = cell.subject else {
            
            self.coordinator?.showOtherSubject(viewModel: self.viewModel)
            return
        }
        
        self.viewModel.currentEditingSubject = subject
        self.viewModel.selectedSubjectColor.value = subject.unwrappedColor
        self.coordinator?.showSubjectCreation(viewModel: self.viewModel)
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

private extension StudyTimeViewController {
    func setContentView(isEmpty: Bool) {
        self.studyTimeView.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        self.addContentSubview(isEmpty ? self.studyTimeView.emptyView : self.studyTimeView.chartController.view)
    }
    
    func addContentSubview(_ subview: UIView) {
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
