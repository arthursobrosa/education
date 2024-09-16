//
//  FocusSelectionViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusSelectionViewController: UIViewController {
    weak var coordinator: (ShowingFocusPicker & ShowingTimer & Dismissing & DismissingAll)?
    let viewModel: FocusSelectionViewModel
    
    private let color: UIColor?
    
    private lazy var focusSelectionView: FocusSelectionView = {
        let view = FocusSelectionView(subjectName: self.viewModel.focusSessionModel.subject?.unwrappedName)
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: FocusSelectionViewModel, color: UIColor?) {
        self.viewModel = viewModel
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.traitCollection.userInterfaceStyle == .light){
            self.view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            self.view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        self.setupUI()
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.focusSelectionView.layer.borderColor = UIColor.label.cgColor
        }
        
        self.setGestureRecognizer()
    }
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        guard !self.focusSelectionView.frame.contains(tapLocation) else { return }
        
        self.coordinator?.dismissAll()
    }
}

extension FocusSelectionViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(focusSelectionView)
        
        NSLayoutConstraint.activate([
            focusSelectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: (471/844)),
            focusSelectionView.widthAnchor.constraint(equalTo: focusSelectionView.heightAnchor, multiplier: (359/471)),
            focusSelectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            focusSelectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
