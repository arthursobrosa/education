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
    
    var subjectName: String?
    private var selectedIndexPath: IndexPath?

    // MARK: - UI Properties

    lazy var subjectCreationView: SubjectCreationView = {
        let view = SubjectCreationView()

        view.layer.cornerRadius = 16
        view.delegate = self

        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(InputTextTableViewCell.self, forCellReuseIdentifier: InputTextTableViewCell.identifier)
        view.tableView.register(ColorPickerCell.self, forCellReuseIdentifier: ColorPickerCell.identifier)

        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DefaultCell.identifier)
        
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let deleteAlertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.layer.zPosition = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.1)
        view.alpha = 0
        view.layer.zPosition = 1
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initialization

    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel

        if let currentEditingSubject = viewModel.currentEditingSubject {
            subjectName = currentEditingSubject.unwrappedName
        }

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.selectedSubjectColor.bind { [weak self] _ in
            guard let self else { return }

            self.reloadTable()
        }
        
        subjectCreationView.hasSubject = viewModel.currentEditingSubject != nil
        
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, traitCollection: UITraitCollection) in
            if traitCollection.userInterfaceStyle == .light {
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }
        
        setupUI()
        setGestureRecognizer()
    }

    // MARK: - Methods

    private func setGestureRecognizer() {
        view.gestureRecognizers = nil
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        
        if deleteAlertView.isHidden {
            guard !subjectCreationView.frame.contains(tapLocation) else { return }

            coordinator?.dismiss(animated: true)
        } else {
            guard !deleteAlertView.frame.contains(tapLocation) else { return }
            
            changeDeleteAlertVisibility(isShowing: false)
        }
    }

    func showUsedSubjectNameAlert(message: String) {
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
    
    func changeDeleteAlertVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            
            self.subjectCreationView.isUserInteractionEnabled = !isShowing
            self.deleteAlertView.isHidden = !isShowing
            self.overlayView.alpha = isShowing ? 1 : 0
            setGestureRecognizer()
        }
    }
}

// MARK: - UI Setup

extension SubjectCreationViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(subjectCreationView)

        NSLayoutConstraint.activate([
            subjectCreationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 366 / 390),
            subjectCreationView.heightAnchor.constraint(equalTo: subjectCreationView.widthAnchor, multiplier: ((subjectName != nil) ? 350 : 280) / 366),
            subjectCreationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subjectCreationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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

        if let index = viewModel.subjectColors.firstIndex(where: { $0 == viewModel.selectedSubjectColor.value }) {
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
        
        let previousColorName = viewModel.selectedSubjectColor.value
        let newColorName = viewModel.subjectColors[indexPath.item]
        let hasColorChanged = previousColorName != newColorName
        viewModel.selectedSubjectColor.value = viewModel.subjectColors[indexPath.item]
        
        if let index = viewModel.subjectColors.firstIndex(where: { $0 == viewModel.selectedSubjectColor.value }) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }
        
        dismiss(animated: true, completion: nil)
        
        if let subjectName,
           !subjectName.isEmpty,
           hasColorChanged {
            
            subjectCreationView.changeSaveButtonState(isEnabled: true)
        }
    }
}

// MARK: - Popover setup

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

// MARK: - TableView Data Source and Delegate

extension SubjectCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        UIView()
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        UIView()
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        5
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        5
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        50
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.identifier, for: indexPath) as? ColorPickerCell else {
                fatalError("Could not dequeue cell")
            }

            cell.backgroundColor = .clear
            cell.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor
            cell.roundCorners(corners: .allCorners, radius: 16, borderWidth: 1, borderColor: UIColor.buttonNormal)
            cell.layer.masksToBounds = true
            cell.selectionStyle = .none
                
            cell.color = viewModel.selectedSubjectColor.value

            return cell
        default:
            return UITableViewCell()
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
