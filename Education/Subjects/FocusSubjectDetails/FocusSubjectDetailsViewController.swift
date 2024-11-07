//
//  FocusSubjectDetailsViewController.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//

import Foundation
import UIKit

class FocusSubjectDetailsViewController: UIViewController {
    let viewModel: StudyTimeViewModel
    
    lazy var focusSubjectDetails: FocusSubjectDetailsView = {
        let view = FocusSubjectDetailsView()
        view.delegate =  self
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    // MARK: - Initializer

    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func loadView() {
        view = focusSubjectDetails
    }
}

// MARK: - TableView Data Source and Delegate

extension FocusSubjectDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
