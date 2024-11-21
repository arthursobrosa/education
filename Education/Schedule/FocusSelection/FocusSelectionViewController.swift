//
//  FocusSelectionViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusSelectionViewController: UIViewController {
    weak var coordinator: (ShowingFocusPicker & ShowingTimer & Dismissing & DismissingAll)?
    let viewModel: FocusSelectionViewModel

    private let color: UIColor?

    private lazy var focusSelectionView: FocusSelectionView = {
        let view = FocusSelectionView(subjectName: self.viewModel.focusSessionModel.subject?.unwrappedName)
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    init(viewModel: FocusSelectionViewModel, color: UIColor?) {
        self.viewModel = viewModel
        self.color = color

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .label.withAlphaComponent(0.2)
        } else {
            view.backgroundColor = .label.withAlphaComponent(0.1)
        }

        setupUI()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.focusSelectionView.layer.borderColor = UIColor.label.cgColor
        }

        setGestureRecognizer()
    }

    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc 
    private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)

        guard !focusSelectionView.frame.contains(tapLocation) else { return }

        coordinator?.dismissAll()
    }
}

extension FocusSelectionViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(focusSelectionView)

        NSLayoutConstraint.activate([
            focusSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 482 / 844),
            focusSelectionView.widthAnchor.constraint(equalTo: focusSelectionView.heightAnchor, multiplier: 366 / 482),
            focusSelectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusSelectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
