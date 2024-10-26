//
//  TestDetailsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import Foundation
import UIKit

class TestDetailsView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Simulado Geral do ENEM"
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 18)
        label.textAlignment = .center
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var circularProgressView: CircularProgressView = {
        let view = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.progressColor = UIColor(named: "defaultColor") ?? .systemBlue
        view.trackColor = .label.withAlphaComponent(0.1)
        view.progress = 0.85 // 85% progresso
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "85%"
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "dateLable")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "28/10/1997"
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 20)
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var questionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "questionsLable")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var questionsLabel: UILabel = {
        let label = UILabel()
        label.text = "17/20"
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var dateStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
//        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var questionsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var horizontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "notesLable")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var notesContent: UILabel = {
        let label = UILabel()
        label.text = "Questões erradas:\n3. Genética\n4. Álgebra\n5. História"
        label.numberOfLines = 0
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(titleLabel)
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
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            percentageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 64),
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

            circularProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 64),
            circularProgressView.centerXAnchor.constraint(equalTo: centerXAnchor),

        ])
    }
}

class CircularProgressView: UIView {
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()

    var progressColor = UIColor.systemBlue {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    var trackColor = UIColor.lightGray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }

    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircularPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircularPath()
    }

    private func setupCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: frame.size.height / 2.0), radius: (frame.size.width) / 2, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)

        // Track layer (background circle)
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 20.0
        trackLayer.lineCap = .round
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)

        // Progress layer (progress circle)
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 20.0
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = progress
        layer.addSublayer(progressLayer)
    }
}
