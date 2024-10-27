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

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchSubjects()

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            view.backgroundColor = .label.withAlphaComponent(0.1)
        }

        viewModel.subjects.bind { [weak self] subjects in
            guard let self else { return }

            self.subjects = subjects
            self.reloadTable()
        }

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.reloadTable()
            self.focusImediateView.layer.borderColor = UIColor.label.cgColor
        }

        setGestureRecognizer()
    }

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

extension FocusImediateViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(focusImediateView)

        NSLayoutConstraint.activate([
            focusImediateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 471 / 844),
            focusImediateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 366 / 390),
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
        return 52 + 12
    }
}
