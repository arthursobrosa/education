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

        // Configurando propriedades da tab bar
        barTintColor = .white
        backgroundColor = .clear
        tintColor = UIColor(named: "system-text")

        // Configurando propriedades dos tab bar items
        itemPositioning = .centered
        itemSpacing = 22
        itemWidth = frame.width * (48 / 390)

        // Adicionando nova layer
        addLayer()

        // Reagindo ao dark e light mode
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, _: UITraitCollection) in

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
        // Criando a sublayer da tabbar
        let roundLayer = CAShapeLayer()

        roundLayer.path = getPath()
        roundLayer.fillColor = traitCollection.userInterfaceStyle == .dark ? UIColor(named: "tab-bg")?.cgColor : UIColor.systemBackground.cgColor

        // Adicionando sombra
        roundLayer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor(named: "tab-shadow")?.cgColor : UIColor.label.cgColor
        roundLayer.shadowOffset = CGSize(width: 0, height: 0)
        roundLayer.shadowOpacity = 0.1
        roundLayer.shadowRadius = 20

        // Adicionando sublayer na tab bar
        layer.insertSublayer(roundLayer, at: 0)
        layer.masksToBounds = false
    }

    private func getPath() -> CGPath {
        let padding = 45.0
        let adjustedRect = CGRect(
            x: padding,
            y: bounds.origin.y - 8,
            width: bounds.width - padding * 2,
            height: bounds.height
        )

        return UIBezierPath(roundedRect: adjustedRect, cornerRadius: 50).cgPath
    }
}
