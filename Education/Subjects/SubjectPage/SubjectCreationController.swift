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
    
    var selectedColor: String?
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
        view = sheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuração da CollectionView
        sheetView.collectionView.delegate = self
        sheetView.collectionView.dataSource = self
        sheetView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        
        // Configuração do botão de salvar
        sheetView.saveButton.addTarget(self, action: #selector(saveSubject), for: .touchUpInside)
    }
    
    // MARK: - Methods
    @objc func saveSubject() {
        guard let name = sheetView.nameTextField.text, !name.isEmpty else {
            showAlert(message: "Por favor, insira um nome para o subject.")
            return
        }
        let existingSubjects = viewModel.subjects.value
        if existingSubjects.contains(where: { $0.name?.lowercased() == name.lowercased() }) {
            showAlert(message: "Já existe um subject com este nome.")
            return
        }
        
        guard let color = selectedColor else {
            showAlert(message: "Por favor, selecione uma cor.")
            return
        }
        
        viewModel.createSubject(name: name, color: color)
        
        self.coordinator?.dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
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
    }
}
