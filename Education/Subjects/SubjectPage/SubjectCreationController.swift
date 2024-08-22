//
//  SubjectCreationController.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationController: UIViewController{
    
    // MARK: - Properties
    var sheetView: SubjectCreationView!
    weak var coordinator: Dismissing?
    let viewModel: StudyTimeViewModel
    
    let colors = ["bluePicker", "blueSkyPicker", "olivePicker", "orangePicker", "pinkPicker", "redPicker", "turquoisePicker", "violetPicker", "yellowPicker"]
    
    var selectedColor: String? = "blueSkyPicker"{
        didSet {
            guard let selectedColor = selectedColor,
                  let colorPickerCell = sheetView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? ColorPickerCell else { return }
            
            colorPickerCell.configure(with: UIColor(named: selectedColor) ?? .clear)
        }
    }
    var subjectName: String?
    var selectedIndexPath: IndexPath?
    var onSave: ((Subject) -> Void)?
    
    
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
        sheetView = SubjectCreationView()
        sheetView.tableView.delegate = self
        sheetView.tableView.dataSource = self
        sheetView.tableView.register(InputTextTableViewCell.self, forCellReuseIdentifier: InputTextTableViewCell.identifier)
        sheetView.tableView.register(ColorPickerCell.self, forCellReuseIdentifier: ColorPickerCell.identifier)
        
        view = sheetView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuração da CollectionView
        sheetView.collectionView.delegate = self
        sheetView.collectionView.dataSource = self
        sheetView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DefaultCell.identifier)
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSubject))
        doneButton.tintColor = .label
        navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(named: "FocusSettingsColor")
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    @objc func cancelButtonTapped() {
        self.coordinator?.dismiss(animated: true)
    }
    
    // MARK: - Methods
    @objc func saveSubject() {
        guard let name = self.subjectName, !name.isEmpty else {
            showAlert(message: String(localized: "subjectCreationNoName"))
            return
        }
        
        let existingSubjects = viewModel.subjects.value
        if existingSubjects.contains(where: { $0.name?.lowercased() == name.lowercased() }) {
            showAlert(message: String(localized: "subjectCreationUsedName"))
            return
        }
        
        guard let color = selectedColor else {
            showAlert(message: String(localized: "subjectCreationNoColor"))
            return
        }
        
        viewModel.createSubject(name: name, color: color)
        
        self.coordinator?.dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: String(localized: "subjectCreationTitle"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension SubjectCreationController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    // UICollectionViewDataSource: Configuração de cada célula
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCell.identifier, for: indexPath)
        cell.backgroundColor = UIColor(named: colors[indexPath.item])
        cell.layer.cornerRadius = 25
        
        if indexPath == selectedIndexPath {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.label.cgColor
        } else {
            cell.layer.borderWidth = 0
        }
        
        return cell
    }
    
    // UICollectionViewDelegate: Ação ao selecionar um item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            let previousCell = collectionView.cellForItem(at: previousIndexPath)
            previousCell?.layer.borderWidth = 0
        }
        
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderWidth = 2
        selectedCell?.layer.borderColor = UIColor.label.cgColor
        
        selectedIndexPath = indexPath
        selectedColor = colors[indexPath.item]
        self.dismiss(animated: true, completion: nil)
    }
}

extension SubjectCreationController {
    func createSubjectPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        let popoverVC = Popover(contentSize: CGSize(width: 170, height: 170))
        let sourceRect = CGRect(x: cell.bounds.midX,
                                y: cell.bounds.midY,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)
        
        self.sheetView.collectionView.delegate = self
        self.sheetView.collectionView.dataSource = self
        // Configurando a customView como a view do popover
        popoverVC.view = self.sheetView.collectionView
        
        return popoverVC
    }
}

extension SubjectCreationController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SubjectCreationController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView() // Retorna uma UIView vazia para o header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView() // Retorna uma UIView vazia para o footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5 // Defina como 0.1 para remover o espaçamento entre as seções
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 // Defina como 0.1 para remover o espaçamento entre as seções
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                let cell = tableView.dequeueReusableCell(withIdentifier: InputTextTableViewCell.identifier, for: indexPath) as! InputTextTableViewCell
                
                if self.traitCollection.userInterfaceStyle == .light {
                    cell.backgroundColor = .systemGray5
                }
                
                cell.onTextChanged = { [weak self] newText in
                    self?.subjectName = newText
                    
                }
                
                if self.traitCollection.userInterfaceStyle == .light {
                    cell.backgroundColor = .systemGray5
                }
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorPickerCell.identifier, for: indexPath)
                
                if self.traitCollection.userInterfaceStyle == .light {
                    cell.backgroundColor = .systemGray5
                }
                
                return cell
                
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
            case 1:
                if let popover = self.createSubjectPopover(forTableView: tableView, at: indexPath) {
                    popover.modalPresentationStyle = .popover
                    self.present(popover, animated: true)
                }
            default:
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
