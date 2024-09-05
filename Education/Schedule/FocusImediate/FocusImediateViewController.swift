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
        
        if(self.traitCollection.userInterfaceStyle == .light){
            self.view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            self.view.backgroundColor = .label.withAlphaComponent(0.1)
        }
       
        
        self.viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            self.subjects = subjects
            self.reloadTable()
        }
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.reloadTable()
            self.focusImediateView.layer.borderColor = UIColor.label.cgColor
            
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
            focusImediateView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: (471/844)),
            focusImediateView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: (366/390)),
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
        
        let subject: Subject? = row == 0 ? nil : self.subjects[row - 1]
        cell.subject = subject
//        cell.color = subject?.unwrappedColor ?? "sealBackgroundColor"
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52 + 12
    }
}
