//
//  CustomTabBar.swift
//  Education
//
//  Created by Arthur Sobrosa on 30/08/24.
//

import UIKit

class CustomTabBar: UITabBar {
    var isSet: Bool = false
    
    override func draw(_ rect: CGRect) {
        guard !isSet else { return }
        
        self.isSet.toggle()
        
        // Configurando propriedades da tab bar
        self.barTintColor = .white
        self.backgroundColor = .clear
        self.tintColor = UIColor(named: "system-text")
        
        // Configurando propriedades dos tab bar items
        self.itemPositioning = .centered
        self.itemSpacing = 22
        self.itemWidth = self.frame.width * (48/390)
        
        // Adicionando nova layer
        self.addLayer()
        
        // Reagindo ao dark e light mode
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            if let roundLayer = self.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer {
                
                
                if(self.traitCollection.userInterfaceStyle == .dark){
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
        
        roundLayer.path = self.getPath()
        roundLayer.fillColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor(named: "tab-bg")?.cgColor : UIColor.systemBackground.cgColor
        
        // Adicionando sombra
        roundLayer.shadowColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor(named: "tab-shadow")?.cgColor : UIColor.label.cgColor
        roundLayer.shadowOffset = CGSize(width: 0, height: 0)
        roundLayer.shadowOpacity = 0.1
        roundLayer.shadowRadius = 20
        
        // Adicionando sublayer na tab bar
        self.layer.insertSublayer(roundLayer, at: 0)
        self.layer.masksToBounds = false
    }
    
    private func getPath() -> CGPath {
        let padding = 45.0
        let adjustedRect = CGRect(
            x: padding,
            y: self.bounds.origin.y - 8,
            width: self.bounds.width - padding * 2,
            height: self.bounds.height
        )
        
        return UIBezierPath(roundedRect: adjustedRect, cornerRadius: 50).cgPath
    }
}


