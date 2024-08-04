//
//  FocusSelectionViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusSelectionViewController: UIViewController {
    weak var coordinator: ShowingFocusPicker?
    let viewModel: FocusSelectionViewModel
    
    private lazy var focusSelectionView: FocusSelectionView = {
        let view = FocusSelectionView()
        view.delegate = self
        
        return view
    }()
    
    init(viewModel: FocusSelectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.focusSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "FocusSelectionColor")
    }
}
