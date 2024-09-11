//
//  UIView+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        
        self.layer.addSublayer(borderLayer)
    }
    
    func createCurve(on roundedCurveCase: RoundedCurveCase, radius: CGFloat = 0, borderWidth: CGFloat, borderColor: UIColor, rect: CGRect) {
        // Cria o path manualmente para desenhar as linhas que você precisa
        let borderPath = UIBezierPath()
        
        var lineWidth = borderWidth
        
        // Define os pontos para desenhar o path
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        switch roundedCurveCase {
            case .top:
                // Começa no canto inferior esquerdo
                borderPath.move(to: bottomLeft)
                
                // Sobe até o canto superior esquerdo e faz a curva
                borderPath.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))
                borderPath.addArc(withCenter: CGPoint(x: topLeft.x + radius, y: topLeft.y + radius),
                                  radius: radius,
                                  startAngle: .pi,
                                  endAngle: 3 * .pi / 2,
                                  clockwise: true)
                
                // Vai até o canto superior direito e faz a curva
                borderPath.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y))
                borderPath.addArc(withCenter: CGPoint(x: topRight.x - radius, y: topRight.y + radius),
                                  radius: radius,
                                  startAngle: 3 * .pi / 2,
                                  endAngle: 0,
                                  clockwise: true)
                
                // Desce até o canto inferior direito (sem borda na parte inferior)
                borderPath.addLine(to: bottomRight)
            case .bottom:
                // Começa no canto superior esquerdo
                borderPath.move(to: topLeft)
                
                // Desce até o canto inferior esquerdo e faz a curva
                borderPath.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius))
                borderPath.addArc(withCenter: CGPoint(x: bottomLeft.x + radius, y: bottomLeft.y - radius),
                                  radius: radius,
                                  startAngle: .pi,
                                  endAngle: .pi / 2,
                                  clockwise: false)
                
                // Vai até o canto inferior direito e faz a curva
                borderPath.addLine(to: CGPoint(x: bottomRight.x - radius, y: bottomRight.y))
                borderPath.addArc(withCenter: CGPoint(x: bottomRight.x - radius, y: bottomRight.y - radius),
                                  radius: radius,
                                  startAngle: .pi / 2,
                                  endAngle: 0,
                                  clockwise: false)
                
                // Sobe até o canto superior direito
                borderPath.addLine(to: topRight)
            case .laterals:
                let xOffset = borderWidth * (0.6/2.5)
                let correctedRect = CGRect(x: self.bounds.origin.x + xOffset, y: self.bounds.origin.y, width: self.bounds.width - xOffset * 2, height: self.bounds.height)
                
                lineWidth = xOffset * 2
                
                // Começa no canto superior esquerdo e desce a lateral esquerda
                borderPath.move(to: CGPoint(x: correctedRect.minX, y: correctedRect.minY))
                borderPath.addLine(to: CGPoint(x: correctedRect.minX, y: correctedRect.maxY))
                
                // Move para o canto inferior direito e sobe a lateral direita
                borderPath.move(to: CGPoint(x: correctedRect.maxX, y: correctedRect.minY))
                borderPath.addLine(to: CGPoint(x: correctedRect.maxX, y: correctedRect.maxY))
        }
        
        // Cria a camada de borda e aplica o path
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = lineWidth
        borderLayer.frame = self.bounds
        
        // Adiciona a camada de borda na view
        self.layer.addSublayer(borderLayer)
    }
}

enum RoundedCurveCase {
    case top
    case bottom
    case laterals
}
