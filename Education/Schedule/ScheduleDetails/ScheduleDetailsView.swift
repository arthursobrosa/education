//
//  ScheduleDetailsView.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleDetailsView: UIView {
    // MARK: - Delegatesm to connect with VC

    weak var delegate: ScheduleDetailsDelegate?
    weak var subjectDelegate: SubjectCreationDelegate?
    weak var popoverDelegate: UIPopoverPresentationControllerDelegate?
    
    // MARK: - Properties
    
    private var selectedIndexPath: IndexPath?
    var isShowingColorPopover: Bool = false
    var newSubjectName: String?

    // MARK: - UI Components

    let tableView: BorderedTableView = {
        let tableView = BorderedTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteActivity"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor.focusColorRed.cgColor
        bttn.layer.borderWidth = 2

        bttn.addTarget(delegate, action: #selector(ScheduleDetailsDelegate.deleteSchedule), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)

        bttn.addTarget(delegate, action: #selector(ScheduleDetailsDelegate.saveSchedule), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()
    
    lazy var subjectCreationView: SubjectCreationView = {
        let view = SubjectCreationView()
        view.isHidden = true
        view.layer.zPosition = 2
        view.layer.cornerRadius = 16
        view.titleLabel.text = String(localized: "newSubject")
        view.delegate = subjectDelegate
        view.hideDeleteButton()
        
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
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.1)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
    
    func changeSubjectCreationView(isShowing: Bool) {
        if isShowing {
            setOverlayTapGesture()
        } else {
            overlayView.gestureRecognizers = nil
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }

            self.subjectCreationView.isHidden = !isShowing
            self.overlayView.alpha = isShowing ? 1 : 0
        }
    }
    
    private func setOverlayTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayViewTapped(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func overlayViewTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: overlayView)
        
        guard !subjectCreationView.frame.contains(tapLocation) else { return }
        
        changeSubjectCreationView(isShowing: false)
    }
    
    func reloadSubjectTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            subjectCreationView.tableView.reloadData()
        }
    }
    
    func changeSaveButtonState(isEnabled: Bool) {
        if isEnabled {
            subjectCreationView.saveButton.backgroundColor = UIColor(named: "button-selected")
            subjectCreationView.saveButton.isUserInteractionEnabled = true
        } else {
            subjectCreationView.saveButton.backgroundColor = UIColor(named: "button-off")
            subjectCreationView.saveButton.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UI Setup

extension ScheduleDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(tableView)
        addSubview(deleteButton)
        addSubview(saveButton)

        let padding = 28.0

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),

            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 55 / 334),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),

            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
        
        addSubview(overlayView)
        addSubview(subjectCreationView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            subjectCreationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 366 / 390),
            subjectCreationView.heightAnchor.constraint(equalTo: subjectCreationView.widthAnchor, multiplier: 280 / 366),
            subjectCreationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            subjectCreationView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension ScheduleDetailsView: UITableViewDataSource, UITableViewDelegate {
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
                
            cell.textField.text = newSubjectName

            cell.backgroundColor = .clear
            cell.roundCorners(corners: .allCorners, radius: 16, borderWidth: 1, borderColor: UIColor.buttonNormal)
            cell.layer.masksToBounds = true

            cell.delegate = subjectDelegate

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
                
            guard let selectedSubjectColor = delegate?.getSelectedSubjectColor() else { return cell}
                
            cell.color = selectedSubjectColor

            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section

        switch section {
        case 1:
            delegate?.showColorPopover()
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScheduleDetailsView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let subjectColors = delegate?.getSubjectColors() else { return 0 }
        
        return subjectColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCell.identifier, for: indexPath)
        
        guard let subjectColors = delegate?.getSubjectColors(),
              let selectedSubjectColor = delegate?.getSelectedSubjectColor() else {
            
            return cell
        }
        
        cell.backgroundColor = UIColor(named: subjectColors[indexPath.item])
        cell.layer.cornerRadius = 25
        
        if let index = subjectColors.firstIndex(where: { $0 == selectedSubjectColor }) {
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
        guard let subjectColors = delegate?.getSubjectColors() else { return }
        
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath)
            previousCell?.layer.borderWidth = 0
        }

        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderWidth = 2
        selectedCell?.layer.borderColor = UIColor.label.cgColor

        delegate?.setSelectedSubjectColor(subjectColors[indexPath.item])
        
        guard let selectedSubjectColor = delegate?.getSelectedSubjectColor() else { return }

        if let index = subjectColors.firstIndex(where: { $0 == selectedSubjectColor }) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }

        delegate?.dismissColorPopover()
    }
}
