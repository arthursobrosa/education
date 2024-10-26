//
//  ActivityBarButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 01/09/24.
//

import UIKit

class ActivityBarButton: UIButton, TimerAnimation {
    // MARK: - Properties

    var color: UIColor? {
        didSet {
            pauseResumeButton.tintColor = color
        }
    }

    // MARK: - UI Properties

    private let timerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let pauseResumeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var timerTrackLayer = CAShapeLayer()
    var timerCircleFillLayer = CAShapeLayer()

    var timerAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        return strokeEnd
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setPauseResumeButton(isPaused: Bool) {
        let imageName = isPaused ? "play.fill" : "pause.fill"

        pauseResumeButton.setImage(UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
    }

    func updatePauseResumeButton(isPaused: Bool) {
        let imageName = isPaused ? "play.fill" : "pause.fill"

        UIView.transition(with: pauseResumeButton, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            guard let self else { return }

            self.pauseResumeButton.setImage(UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        }
    }
}

// MARK: - UI Setup

extension ActivityBarButton: ViewCodeProtocol {
    func setupUI() {
        addSubview(timerContainerView)
        timerContainerView.addSubview(pauseResumeButton)

        NSLayoutConstraint.activate([
            timerContainerView.widthAnchor.constraint(equalTo: widthAnchor),
            timerContainerView.heightAnchor.constraint(equalTo: heightAnchor),
            timerContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            pauseResumeButton.widthAnchor.constraint(equalTo: timerContainerView.widthAnchor),
            pauseResumeButton.heightAnchor.constraint(equalTo: timerContainerView.heightAnchor),
            pauseResumeButton.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor),
            pauseResumeButton.centerYAnchor.constraint(equalTo: timerContainerView.centerYAnchor),
        ])
    }

    func setupLayers(with configuration: ActivityManager.LayersConfig) {
        guard let superview else { return }

        let viewWidth = superview.frame.width * (44 / 366)
        let viewHeight = viewWidth

        let arcPath = UIBezierPath(arcCenter: CGPoint(x: viewWidth / 2, y: viewHeight / 2), radius: viewWidth / 2, startAngle: configuration.startAngle, endAngle: configuration.endAngle, clockwise: configuration.isClockwise)

        let lineWidth = viewWidth * (4 / 44)

        timerTrackLayer.path = arcPath.cgPath
        timerTrackLayer.strokeColor = configuration.isTimerTrackerShowing ? UIColor.systemGray5.cgColor : UIColor.clear.cgColor
        timerTrackLayer.lineWidth = lineWidth
        timerTrackLayer.fillColor = UIColor.clear.cgColor
        timerTrackLayer.lineCap = .round
        timerTrackLayer.strokeEnd = 1

        timerCircleFillLayer.path = arcPath.cgPath
        timerCircleFillLayer.strokeColor = color?.cgColor
        timerCircleFillLayer.lineWidth = lineWidth
        timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        timerCircleFillLayer.lineCap = .round
        timerCircleFillLayer.strokeEnd = configuration.strokeEnd

        pauseResumeButton.layer.addSublayer(timerTrackLayer)
        pauseResumeButton.layer.addSublayer(timerCircleFillLayer)

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }

            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
}
