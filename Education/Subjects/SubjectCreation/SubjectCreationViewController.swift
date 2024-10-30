//
//  SubjectCreationViewController.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: Dismissing?
    let viewModel: StudyTimeViewModel

    // MARK: - Properties

    lazy var subjectCreationView: SubjectCreationView = {
        let view = SubjectCreationView()

        view.delegate = self

        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(InputTextTableViewCell.self, forCellReuseIdentifier: InputTextTableViewCell.identifier)
        view.tableView.register(ColorPickerCell.self, forCellReuseIdentifier: ColorPickerCell.identifier)

        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DefaultCell.identifier)

        return view
    }()

    var subjectName: String?
    private var selectedIndexPath: IndexPath?

    // MARK: - Initialization

    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel

        if let currentEditingSubject = self.viewModel.currentEditingSubject {
            subjectName = currentEditingSubject.unwrappedName
        }

        super.init(nibName: nil, bundle: nil)

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (_: SubjectCreationViewController, _: UITraitCollection?) in
            guard let self = self else { return }
            self.updateViewColors()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = subjectCreationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()

        viewModel.selectedSubjectColor.bind { [weak self] _ in
            guard let self else { return }

            self.reloadTable()
        }
        updateViewColors()

        if viewModel.currentEditingSubject == nil {
            subjectCreationView.hideDeleteButton()
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
            self.coordinator?.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Methods

    private func setNavigationItems() {
        navigationItem.title = viewModel.currentEditingSubject != nil ? String(localized: "editSubject") : String(localized: "newSubject")
        let semiboldFont: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        navigationController?.navigationBar.titleTextAttributes = [.font: semiboldFont, .foregroundColor: UIColor(named: "system-text") as Any]

        let cancelButton = UIButton(configuration: .plain())
        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let attributedCancelTitle = NSAttributedString(string: String(localized: "cancel"), attributes: [.font: regularFont, .foregroundColor: UIColor(named: "system-text-50") as Any])
        cancelButton.setAttributedTitle(attributedCancelTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        let cancelItem = UIBarButtonItem(customView: cancelButton)

        navigationItem.leftBarButtonItem = cancelItem
    }

    @objc
    func cancelButtonTapped() {
        coordinator?.dismiss(animated: true)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: String(localized: "subjectCreationTitle"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.subjectCreationView.tableView.reloadData()
        }
    }

    private func updateViewColors() {
        if let color = UIColor(named: "button-normal", in: nil, compatibleWith: traitCollection) {
            subjectCreationView.tableView.layer.borderColor = color.cgColor
        }
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate

extension SubjectCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.subjectColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCell.identifier, for: indexPath)
        cell.backgroundColor = UIColor(named: viewModel.subjectColors[indexPath.item])
        cell.layer.cornerRadius = 25

        if let index = viewModel.subjectColors.firstIndex(where: { $0 == self.viewModel.selectedSubjectColor.value }) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }

        if indexPath == selectedIndexPath {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.label.cgColor
        } else {
            cell.layer.borderWidth = 0
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath)
            previousCell?.layer.borderWidth = 0
        }

        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderWidth = 2
        selectedCell?.layer.borderColor = UIColor.label.cgColor

        viewModel.selectedSubjectColor.value = viewModel.subjectColors[indexPath.item]

        if let index = viewModel.subjectColors.firstIndex(where: { $0 == self.viewModel.selectedSubjectColor.value }) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }

        dismiss(animated: true, completion: nil)
    }
}

extension SubjectCreationViewController {
    func createColorPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

        let popoverVC = Popover(contentSize: CGSize(width: 190, height: 195))
        let sourceRect = CGRect(x: cell.bounds.maxX - 31,
                                y: cell.bounds.midY + 15,
                                width: 0,
                                height: 0)

        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)

        let paddedView = UIView(frame: CGRect(x: 0, y: 0, width: 190, height: 195))
        paddedView.translatesAutoresizingMaskIntoConstraints = false
        popoverVC.view = paddedView

        paddedView.addSubview(subjectCreationView.collectionView)

        subjectCreationView.collectionView.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([
            subjectCreationView.collectionView.topAnchor.constraint(equalTo: paddedView.topAnchor, constant: padding * 2.5),
            subjectCreationView.collectionView.leadingAnchor.constraint(equalTo: paddedView.leadingAnchor, constant: padding),
            subjectCreationView.collectionView.trailingAnchor.constraint(equalTo: paddedView.trailingAnchor, constant: -padding),
            subjectCreationView.collectionView.bottomAnchor.constraint(equalTo: paddedView.bottomAnchor, constant: -padding),
        ])

        return popoverVC
    }
}

extension SubjectCreationViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for _: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SubjectCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        return UIView() // Retorna uma UIView vazia para o header
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        return UIView() // Retorna uma UIView vazia para o footer
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 5 // Defina como 0.1 para remover o espaçamento entre as seções
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 5 // Defina como 0.1 para remover o espaçamento entre as seções
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1

        case 1:
            return 1

        default:
            break
        }

        return Int()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InputTextTableViewCell.identifier, for: indexPath) as? InputTextTableViewCell else {
                fatalError("Could not dequeue cell")
            }

            cell.textField.text = subjectName

            cell.backgroundColor = .clear
            cell.roundCorners(corners: .allCorners, radius: 16, borderWidth: 1, borderColor: UIColor.buttonNormal)
            cell.layer.masksToBounds = true

            cell.delegate = self

            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.identifier, for: indexPath) as? ColorPickerCell else {
                fatalError("Could not dequeue cell")
            }

            cell.backgroundColor = .clear
            cell.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor
            cell.roundCorners(corners: .allCorners, radius: 16, borderWidth: 1, borderColor: UIColor.buttonNormal)
            cell.layer.masksToBounds = true

            cell.color = viewModel.selectedSubjectColor.value

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section

        switch section {
        case 1:
            if let popover = createColorPopover(forTableView: tableView, at: indexPath) {
                popover.modalPresentationStyle = .popover
                present(popover, animated: true)
            }
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
