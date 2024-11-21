//
//  StudyTimeViewController.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import SwiftUI
import TipKit
import UIKit

class StudyTimeViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    
    weak var coordinator: (ShowingSubjectCreation & ShowingSubjectDetails)?
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
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = studyTimeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.subjects.bind { [weak self] _ in
            guard let self else { return }
            
            self.reloadTable()
        }
        
        viewModel.focusSessions.bind { [weak self] _ in
            guard let self else { return }
            
            self.reloadTable()
        }
        
        setNavigationItems()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                self.studyTimeView.viewModeControl.segmentImage = UIImage(color: UIColor.systemBackground)
            } else {
                self.studyTimeView.viewModeControl.segmentImage = UIImage(color: UIColor.systemBackground)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleTip()
        
        viewModel.fetchFocusSessions()
        viewModel.fetchSubjects()
    }
    
    // MARK: - Methods
    
    private func setNavigationItems() {
        studyTimeView.setNavigationBar()
    }
    
    private func handleTip() {
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
    
    func showDeleteAlert(for subject: Subject) {
        let title = String(localized: "deleteSubjectTitle")
        
        let message = String(format: NSLocalizedString("deleteSubjectMessage", comment: ""), subject.unwrappedName)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmTitle = String(localized: "confirm")
        let cancelTitle = String(localized: "cancel")
        
        let deleteAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in
            self.viewModel.removeSubject(subject: subject)
            self.reloadTable()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showDeleteOtherAlert() {
        let alert = UIAlertController(title: String(localized: "deleteOther"), message: String(localized: "deleteOtherBodyText"), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: String(localized: "confirm"), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.removeSubject(subject: nil)
            self.reloadTable()
        }
        
        let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView Data Source and Delegate

extension StudyTimeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        2
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            1
        } else {
            viewModel.subjects.value.count + 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyTimeChartCell.identifier, for: indexPath) as? StudyTimeChartCell else {
                fatalError("Could not dequeue StudyTimeChartCell")
            }
            
            let chartView = StudyTimeChartView(viewModel: self.viewModel)
            
            cell.configure(with: chartView)
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            if indexPath.row >= viewModel.subjects.value.count + 1 {
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            }
            
            let row = indexPath.row
            let isFixedElement = row == viewModel.subjects.value.count
            let subject: Subject? = isFixedElement ? nil : viewModel.subjects.value[indexPath.row]
            let totalTime = viewModel.getTotalTime(forSubject: subject)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SubjectTimeTableViewCell.identifier, for: indexPath) as? SubjectTimeTableViewCell else {
                fatalError("Could not dequeue cell")
            }
            
            if subject == nil && totalTime == "0min" {
                cell.isHidden = true
                return cell
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            
            cell.subject = subject
            cell.backgroundColor = .clear
            let textColor = subject != nil ? UIColor(named: subject?.unwrappedColor ?? "button-normal") : UIColor.buttonNormal
            cell.subjectName.textColor = textColor
            cell.totalHours.textColor = .systemText80
            cell.totalTime = totalTime
            
            return cell
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            269
        } else {
            60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SubjectTimeTableViewCell,
              let subject = cell.subject else {
            
            coordinator?.showSubjectDetails(subject: nil, studyTimeViewModel: viewModel)
            return
        }
        
        viewModel.currentEditingSubject = subject
        viewModel.selectedSubjectColor.value = subject.unwrappedColor
        coordinator?.showSubjectDetails(subject: subject, studyTimeViewModel: viewModel)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section != 0 else { return nil }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SubjectTimeTableViewCell else { return nil }
        
        let editButton = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _ in
            guard let self else { return }
            
            if let subject = cell.subject {
                self.viewModel.currentEditingSubject = subject
                self.viewModel.selectedSubjectColor.value = subject.unwrappedColor
                self.coordinator?.showSubjectCreation(viewModel: self.viewModel)
            }
        }
        
        editButton.backgroundColor = .systemBackground
        let editImage = UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "system-text") ?? .red)
        editButton.image = editImage
        
        let deleteButton = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _ in
            guard let self else { return }
            
            if let subject = cell.subject {
                self.showDeleteAlert(for: subject)
            } else {
                self.showDeleteOtherAlert()
            }
        }
        
        deleteButton.backgroundColor = .systemBackground
        let deleteImage = UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        deleteButton.image = deleteImage
        
        let row = indexPath.row
        let isFixedElement = row == viewModel.subjects.value.count
        let subject: Subject? = isFixedElement ? nil : viewModel.subjects.value[indexPath.row]
        
        if subject != nil {
            return UISwipeActionsConfiguration(actions: [deleteButton, editButton])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteButton])
        }
    }
    
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        0
    }
    
    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
