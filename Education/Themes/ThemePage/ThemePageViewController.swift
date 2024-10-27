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

    private var contentView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView()

        themeView.delegate = self

        themeView.translatesAutoresizingMaskIntoConstraints = false

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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setNavigationItems()
        setupUI()

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

        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.fetchTests()
    }

    // MARK: - Methods

    private func setNavigationItems() {
        navigationItem.title = viewModel.theme.unwrappedName

        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(addTestButtonTapped), for: .touchUpInside)
        addButton.tintColor = .systemText

        let addItem = UIBarButtonItem(customView: addButton)

        navigationItem.rightBarButtonItems = [addItem]

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .systemText

        navigationItem.leftBarButtonItems = [backButton]
    }

    @objc 
    private func didTapBackButton() {
        coordinator?.dismiss(animated: true)
    }

    func setChart() {
        themePageView.customChart?.removeFromSuperview()
        themePageView.customChart = CustomChart(limit: viewModel.selectedLimit)
        themePageView.customChart?.delegate = self
        let limitedItems = viewModel.getLimitedItems()
        themePageView.customChart?.setData(limitedItems, sorter: \.date, mapTo: \.percentage)
    }

    func setTable() {
        themePageView.tableView = CustomTableView()
        themePageView.tableView?.delegate = self
        themePageView.tableView?.dataSource = self
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ThemePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.tests.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let test = viewModel.tests.value[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as? CustomTableCell else {
            fatalError("Could not dequeue cell")
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

        cell.row = indexPath.row
        cell.numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let test = viewModel.tests.value[indexPath.row]

        coordinator?.showTestDetails(theme: viewModel.theme, test: test)
    }
}

extension ThemePageViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(contentView)

        let padding = 20.0

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }

    private func setContentView(isEmpty: Bool) {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }

        for subview in themePageView.subviews {
            subview.removeFromSuperview()
        }

        if !isEmpty {
            setTable()
            setChart()
        }

        addContentSubview(isEmpty ? themePageView.emptyView : themePageView)
    }

    private func addContentSubview(_ subview: UIView) {
        contentView.addSubview(subview)

        subview.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: contentView.topAnchor),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
