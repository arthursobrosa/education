//
//  CustomTableCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class CustomTableCell: UITableViewCell {
    static let identifier = DefaultCell.identifier

    var row: Int?
    var numberOfRowsInSection = Int()

    private var bordersWereSet = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .systemBackground

        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        removeBorderLayers()

        guard let row,
              numberOfRowsInSection != 0 else { return }

        if !bordersWereSet {
            let radius = bounds.width * (15 / 353)
            let borderWidth = bounds.width * (1.5 / 353)
            let borderColor = UIColor.buttonNormal

            if numberOfRowsInSection == 1 {
                roundCorners(corners: .allCorners, radius: radius * 0.95, borderWidth: borderWidth, borderColor: borderColor)
            } else {
                if row == 0 {
                    createCurve(on: .top, radius: radius, borderWidth: borderWidth, borderColor: borderColor, rect: bounds)
                } else if row == numberOfRowsInSection - 1 {
                    createCurve(on: .bottom, radius: radius, borderWidth: borderWidth, borderColor: borderColor, rect: bounds)
                } else {
                    createCurve(on: .laterals, borderWidth: borderWidth, borderColor: borderColor, rect: bounds)
                }
            }

            bordersWereSet = true
        }
    }

    func setAccessoryView(_ accessoryView: UIView?) {
        guard let accessoryView else { return }

        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(accessoryView)

        NSLayoutConstraint.activate([
            accessoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),

        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        row = nil
        numberOfRowsInSection = 0
        bordersWereSet = false
        removeBorderLayers()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bordersWereSet = false
            updateBorderColor(traitCollection)
        }
    }

    private func updateBorderColor(_: UITraitCollection) {
        setNeedsLayout()
    }

    private func removeBorderLayers() {
        guard let sublayers = layer.sublayers else { return }

        for layer in sublayers {
            if layer.name == "borderLayer" || layer.name == "borderLayer2" {
                layer.removeFromSuperlayer()
            }
        }
    }
}
