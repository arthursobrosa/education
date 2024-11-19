//
//  ThemePageViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import SwiftUI
import UIKit

class ThemePageViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (ShowingTestDetails & Dismissing & ShowingTestPage)?
    let viewModel: ThemePageViewModel

    // MARK: - Properties
    
    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView()
        themeView.delegate = self
        return themeView
    }()

    // MARK: - Initialization

    init(viewModel: ThemePageViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        view = themePageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()

        viewModel.tests.bind { [weak self] tests in
            guard let self else { return }

            self.setContentView(isEmpty: tests.isEmpty)
        }

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                self.themePageView.segmentedControl.segmentImage = UIImage(color: UIColor.systemBackground)
            } else {
                self.themePageView.segmentedControl.segmentImage = UIImage(color: UIColor.systemBackground)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = viewModel.theme?.unwrappedName
        viewModel.fetchTests()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.title = ""
    }

    // MARK: - Methods

    private func setNavigationItems() {
        guard let themeName = viewModel.theme?.unwrappedName else { return }
        let navigationTitle = themeName
        themePageView.setNavigationBar(with: navigationTitle)
    }

    func setChart() {
        themePageView.customChart?.removeFromSuperview()
        themePageView.customChart = CustomChart(limit: viewModel.selectedLimit)
        themePageView.customChart?.delegate = self
        let limitedItems = viewModel.getLimitedItems()
        themePageView.customChart?.setData(limitedItems, sorter: \.date, mapTo: \.percentage)
    }

    func setTable() {
        themePageView.tableView = BorderedTableView()
        themePageView.tableView?.delegate = self
        themePageView.tableView?.dataSource = self
    }
}

// MARK: - UI Setup

extension ThemePageViewController {
    private func setContentView(isEmpty: Bool) {
        for subview in themePageView.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        if isEmpty {
            addContentSubview(parentSubview: themePageView.contentView, childSubview: themePageView.emptyView)
        } else {
            setTable()
            setChart()
        }
    }

    private func addContentSubview(parentSubview: UIView, childSubview: UIView) {
        parentSubview.addSubview(childSubview)

        childSubview.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            childSubview.topAnchor.constraint(equalTo: parentSubview.topAnchor),
            childSubview.leadingAnchor.constraint(equalTo: parentSubview.leadingAnchor),
            childSubview.trailingAnchor.constraint(equalTo: parentSubview.trailingAnchor),
            childSubview.bottomAnchor.constraint(equalTo: parentSubview.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ThemePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? BorderedTableCell else { return }
        cell.configureCell(tableView: tableView, forRowAt: indexPath)
    }
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.tests.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let test = viewModel.tests.value[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTableCell.identifier, for: indexPath) as? BorderedTableCell else {
            fatalError("Could not dequeue bordered table cell")
        }
        let hasComment = viewModel.hasComment(test: test)

        cell.textLabel?.text = viewModel.getDateString(from: test)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.textLabel?.textColor = .systemText

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let commentView = UIImageView()
        commentView.image = UIImage(systemName: "text.bubble")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
        commentView.tintColor = .systemText30
        let label = UILabel()
        label.text = viewModel.getQuestionsString(from: test)
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .systemText30
        label.sizeToFit()

        let percentage = UILabel()
        let percentDouble = Double(test.unwrappedRightQuestions * 100) / Double(test.unwrappedTotalQuestions)
        let percentInt = Int(percentDouble)
        let percentText = String(percentInt)
        percentage.text = "(" + percentText + "%)"
        percentage.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        percentage.textColor = .systemGray
        percentage.sizeToFit()

        if hasComment {
            stackView.addArrangedSubview(commentView)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(percentage)
            cell.setAccessoryView(stackView)
        } else {
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(percentage)
            cell.setAccessoryView(stackView)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let test = viewModel.tests.value[indexPath.row]

        guard let theme = viewModel.theme else {return}
        coordinator?.showTestDetails(theme: theme, test: test)
    }
}
