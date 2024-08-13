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
        let view = FocusSelectionView(color: self.color)
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
        
        self.view.backgroundColor = .systemBackground.withAlphaComponent(0.6)
        
        self.setupUI()
    }
}

extension FocusSelectionViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(focusSelectionView)
        
        NSLayoutConstraint.activate([
            focusSelectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: (588/844)),
            focusSelectionView.widthAnchor.constraint(equalTo: focusSelectionView.heightAnchor, multiplier: (359/588)),
            focusSelectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            focusSelectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
