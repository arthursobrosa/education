//
//  NewThemeViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class NewThemeViewController: UIViewController {
    weak var coordinator: Dismissing?
    let viewModel: ThemeListViewModel
    
    private lazy var newThemeView: NewThemeView = {
        let view = NewThemeView()
        view.delegate = self
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: ThemeListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        if self.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            self.view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            if previousTraitCollection.userInterfaceStyle == .dark {
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }
        
        self.setupUI()
    }
}

extension NewThemeViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(newThemeView)
        
        NSLayoutConstraint.activate([
            newThemeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 366/390),
            newThemeView.heightAnchor.constraint(equalTo: newThemeView.widthAnchor, multiplier: 228/366),
            newThemeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            newThemeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
