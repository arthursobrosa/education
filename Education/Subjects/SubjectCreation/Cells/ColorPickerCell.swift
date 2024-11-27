//
//  ColorPickerCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class ColorPickerCell: UITableViewCell {
    // MARK: - Identifier
    
    static let identifier = "colorPickerCell"

    // MARK: - Properties
    
    var color: String? {
        didSet {
            guard let color else { return }

            colorCircleView.backgroundColor = UIColor(named: color)
        }
    }

    // MARK: - UI Properties
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "color")
        label.textColor = .systemText80
        label.font = .init(name: Fonts.darkModeOnMedium, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let colorCircleView: RainbowCircle = {
        let view = RainbowCircle(frame: CGRect(x: 0, y: 0, width: 30, height: 30), lineHeight: 2)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI Setup

extension ColorPickerCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCircleView)

        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            colorCircleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircleView.widthAnchor.constraint(equalToConstant: 30), // Largura da bolinha
            colorCircleView.heightAnchor.constraint(equalToConstant: 30), // Altura da bolinha
        ])
    }
}

// MARK: - Subviews

class RainbowCircle: UIView {
    private var radius: CGFloat {
        return frame.width > frame.height ? frame.height / 2 : frame.width / 2
    }

    private var stroke: CGFloat = 10
    private var padding: CGFloat = 0

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawRainbowCircle(outerRadius: radius - padding, innerRadius: radius - stroke - padding, resolution: 1)
    }

    init(frame: CGRect, lineHeight: CGFloat) {
        super.init(frame: frame)
        stroke = lineHeight
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }

    private func drawRainbowCircle(outerRadius: CGFloat, innerRadius: CGFloat, resolution: Float) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        context.translateBy(x: bounds.midX, y: bounds.midY) // Move context to center

        let subdivisions = CGFloat(resolution * 512) // Max subdivisions of 512

        let innerHeight = (CGFloat.pi * innerRadius) / subdivisions // height of the inner wall for each segment
        let outterHeight = (CGFloat.pi * outerRadius) / subdivisions

        let segment = UIBezierPath()
        segment.move(to: CGPoint(x: innerRadius, y: -innerHeight / 2))
        segment.addLine(to: CGPoint(x: innerRadius, y: innerHeight / 2))
        segment.addLine(to: CGPoint(x: outerRadius, y: outterHeight / 2))
        segment.addLine(to: CGPoint(x: outerRadius, y: -outterHeight / 2))
        segment.close()

        // Draw each segment and rotate around the center
        for i in 0 ..< Int(ceil(subdivisions)) {
            UIColor(hue: CGFloat(i) / subdivisions, saturation: 1, brightness: 1, alpha: 1).set()
            segment.fill()
            // let lineTailSpace = CGFloat.pi*2*outerRadius/subdivisions  //The amount of space between the tails of each segment
            let lineTailSpace = CGFloat.pi * 2 * outerRadius / subdivisions
            segment.lineWidth = lineTailSpace // allows for seemless scaling
            segment.stroke()

            // Rotate to correct location
            let rotate = CGAffineTransform(rotationAngle: -(CGFloat.pi * 2 / subdivisions)) // rotates each segment
            segment.apply(rotate)
        }

        context.translateBy(x: -bounds.midX, y: -bounds.midY) // Move context back to original position
        context.restoreGState()
    }
}
