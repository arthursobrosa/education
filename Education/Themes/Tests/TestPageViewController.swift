//
//  TestPageViewController.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation
import UIKit

class TestPageViewController: UIViewController {
    // MARK: - ViewModel
    let viewModel: ThemePageViewModel
    
    // MARK: - Properties
    private lazy var themeRightQuestionsView: TestPageView = {
        let view = TestPageView()
        
        view.delegate = self
        
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: ThemePageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.themeRightQuestionsView
    }

    // MARK: - Methods
    func showWrongQuestionsAlert() {
        let alertController = UIAlertController(title: String(localized: "wrongQuestionsTitle"), message: String(localized: "wrongQuestionsMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
