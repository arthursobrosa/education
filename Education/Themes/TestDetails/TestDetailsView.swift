//
//  TestDetailsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import Foundation
import UIKit

class TestDetailsView: UIView {
    // MARK: - Delegate to connect with VC
    
    weak var delegate: TestDetailsDelegate?
    
    // MARK: - Properties
    
    struct Config {
        var titleText: String
        var notesText: String
        var questionsText: String
        var themeTitleText: String
        var progress: CGFloat
        var dateText: String
        var percentageText: String
    }
    
    var config: Config? {
        didSet {
            guard let config else { return }
            
            titleLabel.text = config.titleText
            notesContent.text = config.notesText
            questionsLabel.text = config.questionsText
            themeTitleLabel.text = config.themeTitleText
            circularProgressView.progress = config.progress
            dateLabel.text = config.dateText
            percentageLabel.text = config.percentageText
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemText40
        button.addTarget(delegate, action: #selector(TestDetailsDelegate.didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        button.tintColor = .systemText
        button.addTarget(delegate, action: #selector(TestDetailsDelegate.didTapEditButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let themeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 18)
        label.textAlignment = .center
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let circularProgressView: CircularProgressView = {
        let view = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.progressColor = UIColor(named: "defaultColor") ?? .systemBlue
        view.trackColor = .label.withAlphaComponent(0.1)
        view.progress = 0.85 // 85% progresso
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "dateLabel")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 20)
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let questionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "questionsLabel")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let questionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let questionsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let notesLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "notesLabel")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notesContent: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        textView.textColor = .systemText
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension TestDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(editButton)
        addSubview(themeTitleLabel)
        addSubview(circularProgressView)
        addSubview(horizontalStack)
        addSubview(percentageLabel)
        addSubview(notesLabel)
        addSubview(notesContent)

        dateStack.addArrangedSubview(dateTitleLabel)
        dateStack.addArrangedSubview(dateLabel)

        questionsStack.addArrangedSubview(questionsTitleLabel)
        questionsStack.addArrangedSubview(questionsLabel)

        horizontalStack.addArrangedSubview(dateStack)
        let spacer = UIView()
        horizontalStack.addArrangedSubview(spacer)
        horizontalStack.addArrangedSubview(questionsStack)

        let padding = 24.0

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 56),
            backButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 27 / 390),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 54),
            editButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 27 / 390),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
            
            themeTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11),
            themeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            themeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),

            percentageLabel.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: 64),
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.widthAnchor.constraint(equalToConstant: 200),
            percentageLabel.heightAnchor.constraint(equalToConstant: 200),

            horizontalStack.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 48),
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            notesLabel.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 32),
            notesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            notesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            notesContent.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 4),
            notesContent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            notesContent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            notesContent.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 200 / 844),

            circularProgressView.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: 64),
            circularProgressView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
