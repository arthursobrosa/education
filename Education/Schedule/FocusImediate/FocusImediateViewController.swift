//
//  FocusImediateViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    
    weak var coordinator: (ShowingFocusSelection & Dismissing)?
    private let viewModel: FocusImediateViewModel

    // MARK: - Properties
    
    var subjects = [Subject]()

    // MARK: - UI Properties
    
    private lazy var focusImediateView: FocusImediateView = {
        let view = FocusImediateView()
        view.delegate = self

        view.subjectsTableView.dataSource = self
        view.subjectsTableView.delegate = self
        view.subjectsTableView.register(FocusSubjectTableViewCell.self, forCellReuseIdentifier: FocusSubjectTableViewCell.identifier)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Initializer
    
    init(viewModel: FocusImediateViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchSubjects()

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            view.backgroundColor = .label.withAlphaComponent(0.1)
        }
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, traitCollection: UITraitCollection) in
            if traitCollection.userInterfaceStyle == .light {
                self.view.backgroundColor = .label.withAlphaComponent(0.2)
            } else {
                self.view.backgroundColor = .label.withAlphaComponent(0.1)
            }
        }

        viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }
            
            self.subjects = subjects
            self.reloadTable()
        }

        setupUI()
        setGestureRecognizer()
    }

    // MARK: - Methods
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.focusImediateView.subjectsTableView.reloadData()
        }
    }

    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc 
    private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)

        guard !focusImediateView.frame.contains(tapLocation) else { return }

        coordinator?.dismiss(animated: true)
    }
}

// MARK: - UI Setup

extension FocusImediateViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(focusImediateView)

        NSLayoutConstraint.activate([
            focusImediateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 482 / 844),
            focusImediateView.widthAnchor.constraint(equalTo: focusImediateView.heightAnchor, multiplier: 366 / 482),
            focusImediateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusImediateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension FocusImediateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        subjects.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FocusSubjectTableViewCell.identifier, for: indexPath) as? FocusSubjectTableViewCell else {
            fatalError("Could not dequeue cell")
        }

        let subject: Subject? = row == 0 ? nil : subjects[row - 1]
        cell.subject = subject
        cell.indexPath = indexPath
        cell.delegate = self

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 68
    }
}
