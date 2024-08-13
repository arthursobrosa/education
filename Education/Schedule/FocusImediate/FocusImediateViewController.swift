//
//  FocusImediateViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateViewController: UIViewController {
    weak var coordinator: (ShowingFocusSelection & Dismissing)?
    private let viewModel: FocusImediateViewModel
    
    let color: UIColor?
    var subjects = [Subject]()
    
    private lazy var focusImediateView: FocusImediateView = {
        let view = FocusImediateView(color: self.color)
        view.delegate = self
        
        view.subjectsTableView.dataSource = self
        view.subjectsTableView.delegate = self
        view.subjectsTableView.register(FocusSubjectTableViewCell.self, forCellReuseIdentifier: FocusSubjectTableViewCell.identifier)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(viewModel: FocusImediateViewModel, color: UIColor?) {
        self.viewModel = viewModel
        self.color = color
        
        super.init(nibName: nil, bundle: nil)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.fetchSubjects()
        
        self.view.backgroundColor = .systemBackground.withAlphaComponent(0.6)
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            self.subjects = subjects
            self.reloadTable()
        }
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.focusImediateView.subjectsTableView.reloadData()
        }
    }
}

extension FocusImediateViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(focusImediateView)
        
        NSLayoutConstraint.activate([
            focusImediateView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: (588/844)),
            focusImediateView.widthAnchor.constraint(equalTo: focusImediateView.heightAnchor, multiplier: (359/588)),
            focusImediateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            focusImediateView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension FocusImediateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.subjects.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FocusSubjectTableViewCell.identifier, for: indexPath) as? FocusSubjectTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        
        let subject: Subject? = row >= self.subjects.count ? nil : self.subjects[row]
        cell.subject = subject
        cell.color = self.color
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52 + 12
    }
}
