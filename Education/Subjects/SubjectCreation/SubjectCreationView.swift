//
//  SubjectCreationView.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationView: UIView {
    // MARK: - Delegate to connect with VC
    
    weak var delegate: SubjectCreationDelegate?
    
    // MARK: - Properties
    
    var hasSubject: Bool = false {
        didSet {
            if hasSubject {
                titleLabel.text = String(localized: "editSubject")
            } else {
                deleteButton.isHidden = true
                titleLabel.text = String(localized: "newSubject")
            }
        }
    }

    // MARK: - UI Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = UIColor(named: "systemText")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "xmark")
        button.setImage(img, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor(named: "system-text-40")
        button.setPreferredSymbolConfiguration(.init(pointSize: 16), forImageIn: .normal)
        button.addTarget(delegate, action: #selector(SubjectCreationDelegate.didTapCloseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.isScrollEnabled = false
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var deleteButton: ButtonComponent = {
        let attributedText = NSMutableAttributedString()

        let symbolAttachment = NSTextAttachment()
        let symbolImage = UIImage(systemName: "trash")?.withRenderingMode(.alwaysTemplate)
        symbolAttachment.image = symbolImage
        symbolAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
        
        let symbolAttributedString = NSAttributedString(attachment: symbolAttachment)
        attributedText.append(symbolAttributedString)
        attributedText.append(NSAttributedString(string: "   "))
        attributedText.append(NSAttributedString(string: String(localized: "deleteSubjectTitle")))

        let button = ButtonComponent(attrString: attributedText, textColor: UIColor(named: "focus-color-red"), cornerRadius: 26)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(named: "focus-color-red")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(SubjectCreationDelegate.didTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var saveButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"), cornerRadius: 27)
        button.isUserInteractionEnabled = false
        button.addTarget(delegate, action: #selector(SubjectCreationDelegate.didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "button-off")
        return button
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    func changeSaveButtonState(isEnabled: Bool) {
        if isEnabled {
            saveButton.backgroundColor = .buttonSelected
            saveButton.isUserInteractionEnabled = true
        } else {
            saveButton.backgroundColor = .buttonOff
            saveButton.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UI Setup

extension SubjectCreationView: ViewCodeProtocol {
    func setupUI() {
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(deleteButton)
        addSubview(saveButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -0),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),

            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 55 / 334),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -11),

            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
}
