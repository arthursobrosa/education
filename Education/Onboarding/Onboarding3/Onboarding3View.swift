//
//  Onboarding3View.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/11/24.
//

import UIKit

class Onboarding3View: OnboardingView {
    // MARK: - Delegate to connect with VC
    
    weak var onboarding3Delegate: Onboarding3Delegate?
    
    // MARK: - Properties
    
    var subjectNames: [String] = [] {
        didSet {
            reloadCollection()
        }
    }
    
    // MARK: - UI Properties
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    private lazy var subjectsCollectionView: UICollectionView = {
        let layout = CenterAlignedViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(SubjectCollectionCell.self, forCellWithReuseIdentifier: SubjectCollectionCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var subjectPlusView: SubjectPlusView = {
        let view = SubjectPlusView()
        view.addTarget(self, action: #selector(subjectPlusViewTapped))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var newSubjectTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.bluePicker.cgColor
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 18
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.isHidden = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: Initializer
    
    init() {
        super.init(showsBackButton: true)
        setTitleStack()
        layoutContent()
        addKeyboardOberservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubjectsCollectionHeight()
    }
    
    // MARK: - Methods
    
    private func setTitleStack() {
        let names: [String] = [
            String(localized: "letsStart"),
            String(localized: "addSubjects"),
        ]
        
        for name in names {
            let label = getLabel(withName: name)
            titleStackView.addArrangedSubview(label)
        }
    }
    
    private func getLabel(withName name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        let font: UIFont = .init(name: Fonts.darkModeOnRegular, size: 17) ?? .systemFont(ofSize: 17, weight: .regular)
        label.font = font
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.subjectsCollectionView.reloadData()
        }
    }

    @objc
    private func subjectPlusViewTapped() {
        newSubjectTextField.becomeFirstResponder()
    }
    
    private func updateSubjectsCollectionHeight() {
        let collectionHeight = subjectsCollectionView.collectionViewLayout.collectionViewContentSize.height
        let maxHeight = bounds.height * (391 / 844)
        
        if collectionHeight <= maxHeight {
            collectionHeightConstraint?.constant = collectionHeight
        } else {
            collectionHeightConstraint?.constant = maxHeight
        }
        
        layoutIfNeeded()
    }
    
    private func addKeyboardOberservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangedFirstResponder), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc 
    private func keyboardChangedFirstResponder(notification: Notification) {
        switch notification.name {
        case UIResponder.keyboardWillShowNotification:
            newSubjectTextField.isHidden = false
        case UIResponder.keyboardWillHideNotification:
            newSubjectTextField.isHidden = true
        default:
            break
        }
    }
}

// MARK: UI Setup

extension Onboarding3View {
    private func layoutContent() {
        addSubview(titleStackView)
        addSubview(subjectsCollectionView)
        addSubview(subjectPlusView)
        addSubview(newSubjectTextField)
        
        collectionHeightConstraint = subjectsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 134),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            subjectsCollectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 41),
            subjectsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            subjectsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
            
            subjectPlusView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 28 / 390),
            subjectPlusView.heightAnchor.constraint(equalTo: subjectPlusView.widthAnchor),
            subjectPlusView.topAnchor.constraint(equalTo: subjectsCollectionView.bottomAnchor, constant: 18),
            subjectPlusView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            newSubjectTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            newSubjectTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
            newSubjectTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 50 / 844),
            newSubjectTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
}

// MARK: - Subject Collection Data Source and Delegate

extension Onboarding3View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        subjectNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCollectionCell.identifier, for: indexPath) as? SubjectCollectionCell else {
            fatalError("Could not dequeue subject collection cell")
        }
        
        var subjectName = subjectNames[indexPath.row]
        subjectName = String(subjectName.prefix(25))
        cell.subjectName = subjectName
        
        if let isSelected = onboarding3Delegate?.isSelected(atIndex: indexPath.row) {
            cell.isSelectedSubject = isSelected
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SubjectCollectionCell {
            cell.isSelectedSubject.toggle()
            
            if cell.isSelectedSubject {
                onboarding3Delegate?.addSubjectName(forSubjectIndex: indexPath.row)
            } else {
                onboarding3Delegate?.removeSubjectName(fromSubjectIndex: indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        tempLabel.numberOfLines = 1
        tempLabel.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        let text = subjectNames[indexPath.row]
        tempLabel.text = text
        
        let targetSize = CGSize(width: collectionView.bounds.width - 24, height: CGFloat.greatestFiniteMagnitude)
        let size = tempLabel.sizeThatFits(targetSize)
        var height = size.height + 10
        height = min(height, 40)
        let availableWidth = collectionView.bounds.width / 2
        let width = min(size.width + 24, availableWidth)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
}

// MARK: - Text Field Delegate

extension Onboarding3View: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
           !text.isEmpty {
            
            onboarding3Delegate?.createNewSubjectName(text)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Preview

#Preview {
    Onboarding3ViewController(viewModel: OnboardingManagerViewModel())
}
