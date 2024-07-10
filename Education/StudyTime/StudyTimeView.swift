//
//  StudyTimeView.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeView: UIView {
    
    // MARK: - UI Components
    lazy var placeholder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var studyTimeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubjectTimeCell")
        return tableView
    }()
    
    private var viewModel: StudyTimeViewModel
    
    // MARK: - Initialization
        
    init(viewModel: StudyTimeViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reload Table
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.studyTimeTableView.reloadData()
        }
    }
}

// MARK: - UI Setup
extension StudyTimeView: ViewCodeProtocol {
    func setupUI() {
        addSubview(placeholder)
        addSubview(studyTimeTableView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            placeholder.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeholder.widthAnchor.constraint(equalToConstant: 200),
            placeholder.heightAnchor.constraint(equalToConstant: 200),
            
            studyTimeTableView.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: padding),
            studyTimeTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            studyTimeTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            studyTimeTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
        
    }
}
