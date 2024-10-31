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
        navigationItem.title = String(localized: "subjectTab")
        let regularFont: UIFont = UIFont(name: Fonts.coconRegular, size: Fonts.titleSize) ?? UIFont.systemFont(ofSize: Fonts.titleSize, weight: .regular)
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: regularFont, .foregroundColor: UIColor(named: "system-text") as Any]

        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        addButton.tintColor = UIColor(named: "system-text")

        let addItem = UIBarButtonItem(customView: addButton)

        navigationItem.rightBarButtonItems = [addItem]
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

    @objc 
    func listButtonTapped() {
        coordinator?.showSubjectCreation(viewModel: viewModel)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension StudyTimeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.subjects.value.count + 3
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
            cell.subjectName.textColor = UIColor(named: subject?.unwrappedColor ?? "button-normal")
            cell.totalHours.textColor = UIColor(named: subject?.unwrappedColor ?? "button-normal")
            cell.totalTime = totalTime

            return cell
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 269
        } else {
            return 60
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }

        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) as? SubjectTimeTableViewCell,
              let subject = cell.subject
        else {
            coordinator?.showOtherSubject(viewModel: viewModel)
            return
        }

        viewModel.currentEditingSubject = subject
        viewModel.selectedSubjectColor.value = subject.unwrappedColor
        coordinator?.showSubjectCreation(viewModel: viewModel)
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 0
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
