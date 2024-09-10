//
//  OtherSubjectViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 03/09/24.
//

import Foundation
import UIKit

class OtherSubjectViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: Dismissing?
    let viewModel: StudyTimeViewModel
    
    // MARK: - Properties
    private lazy var otherSubjectView: OtherSubjectView = {
        let view = OtherSubjectView()
        view.delegate = self
        
        return view
    }()
    
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
        super.loadView()
        self.view = self.otherSubjectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationItems()
    }
    
    // MARK: - Methods
    private func setupNavigationItems() {
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = UIColor(named: "FocusSettingsColor")
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func cancelButtonTapped() {
        self.coordinator?.dismiss(animated: true)
    }
    
}



protocol OtherSubjectDelegate: AnyObject {
    func deleteOtherSubjectTime()
}

extension OtherSubjectViewController: OtherSubjectDelegate {
    func deleteOtherSubjectTime() {
        let alert = UIAlertController(title: String(localized: "deleteOther"), message: String(localized: "deleteOtherMessage"), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: String(localized: "confirm"), style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            deleteTime()
        }
        let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteTime(){
        self.viewModel.removeSubject(subject: nil)
        self.coordinator?.dismiss(animated: true)
    }
    
    
}
