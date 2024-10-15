//
//  TestDetailsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import UIKit
import Foundation

class TestDetailsView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Simulado Geral do ENEM"
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 18)
        label.textAlignment = .center
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
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "28/10/1997"
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var questionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "questionsLable")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var questionsLabel: UILabel = {
        let label = UILabel()
        label.text = "17/20"
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
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
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var notesContent: UILabel = {
        let label = UILabel()
        label.text = "Questões erradas:\n3. Genética\n4. Álgebra\n5. História"
        label.numberOfLines = 0
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          
          self.backgroundColor = .systemBackground
         
          self.setupUI()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    
    private func setupUI() {
        
        self.addSubview(titleLabel)
        self.addSubview(circularProgressView)
        self.addSubview(horizontalStack)
        self.addSubview(percentageLabel)
        self.addSubview(notesLabel)
        self.addSubview(notesContent)
        
        self.dateStack.addArrangedSubview(dateTitleLabel)
        self.dateStack.addArrangedSubview(dateLabel)
        
        self.questionsStack.addArrangedSubview(questionsTitleLabel)
        self.questionsStack.addArrangedSubview(questionsLabel)
        
        self.horizontalStack.addArrangedSubview(dateStack)
        let spacer = UIView()
        self.horizontalStack.addArrangedSubview(spacer)
        self.horizontalStack.addArrangedSubview(questionsStack)
        
        
        let padding = 24.0;
        
        NSLayoutConstraint.activate([
            
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.percentageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 64),
            self.percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.percentageLabel.widthAnchor.constraint(equalToConstant: 200),
            self.percentageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            
            self.horizontalStack.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 48),
            self.horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            self.horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            self.notesLabel.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 32),
            self.notesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            self.notesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            self.notesContent.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 4),
            self.notesContent.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            self.notesContent.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            
            self.circularProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 64),
            self.circularProgressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            
            
        
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
        progressLayer.strokeEnd = self.progress
        layer.addSublayer(progressLayer)
    }
    
}

