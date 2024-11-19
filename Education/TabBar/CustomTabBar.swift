//
//  CustomTabBar.swift
//  Education
//
//  Created by Arthur Sobrosa on 30/08/24.
//

import UIKit

class CustomTabBar: UITabBar {
    var isSet: Bool = false

    override func draw(_: CGRect) {
        guard !isSet else { return }

        isSet.toggle()

        barTintColor = .white
        backgroundColor = .clear
        tintColor = UIColor(named: "system-text")

        itemPositioning = .centered
        itemSpacing = 22
        itemWidth = frame.width * (48 / 390)

        addLayer()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            if let roundLayer = self.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer {
                if self.traitCollection.userInterfaceStyle == .dark {
                    roundLayer.shadowColor = UIColor(named: "tab-shadow")?.cgColor
                    roundLayer.fillColor = UIColor(named: "tab-bg")?.cgColor
                } else {
                    roundLayer.shadowColor = UIColor.label.cgColor
                    roundLayer.fillColor = UIColor.systemBackground.cgColor
                }
            }

            self.tintColor = .label
        }
    }

    private func addLayer() {
        let roundLayer = CAShapeLayer()

        roundLayer.path = getPath()
        roundLayer.fillColor = traitCollection.userInterfaceStyle == .dark ? UIColor(named: "tab-bg")?.cgColor : UIColor.systemBackground.cgColor

        roundLayer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor(named: "tab-shadow")?.cgColor : UIColor.label.cgColor
        roundLayer.shadowOffset = CGSize(width: 0, height: 0)
        roundLayer.shadowOpacity = 0.1
        roundLayer.shadowRadius = 20

        layer.insertSublayer(roundLayer, at: 0)
        layer.masksToBounds = false
    }

    private func getPath() -> CGPath {
        let width = bounds.width * (240 / 390)
        let yOffset = bounds.height * (6 / 65)
        
        let adjustedRect = CGRect(
            x: bounds.midX - width / 2,
            y: bounds.origin.y - yOffset,
            width: width,
            height: bounds.height
        )

        return UIBezierPath(roundedRect: adjustedRect, cornerRadius: 50).cgPath
    }
}
