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
    
    func createRoundedCurve(on roundedCurveCase: RoundedCurveCase, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, rect: CGRect) {
        // Cria o path manualmente para desenhar as linhas que você precisa
        let borderPath = UIBezierPath()
        
        // Define os pontos para desenhar o path
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeft = CGPoint(x: rect.minX, y: rect.minY + radius)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY + radius)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        switch roundedCurveCase {
            case .top:
                // Começa no canto inferior esquerdo
                borderPath.move(to: bottomLeft)
                
                // Sobe até o canto superior esquerdo e faz a curva
                borderPath.addLine(to: topLeft)
                borderPath.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                                  radius: radius,
                                  startAngle: .pi,
                                  endAngle: 3 * .pi / 2,
                                  clockwise: true)
                
                // Vai até o canto superior direito e faz a curva
                borderPath.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
                borderPath.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
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
                borderPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
                borderPath.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                                  radius: radius,
                                  startAngle: .pi,
                                  endAngle: .pi / 2,
                                  clockwise: false)
                
                // Vai até o canto inferior direito e faz a curva
                borderPath.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.maxY))
                borderPath.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                                  radius: radius,
                                  startAngle: .pi / 2,
                                  endAngle: 0,
                                  clockwise: false)
                
                // Sobe até o canto superior direito
                borderPath.addLine(to: topRight)
            case .laterals:
                // Começa no canto superior esquerdo e desce a lateral esquerda
                borderPath.move(to: topLeft)
                borderPath.addLine(to: bottomLeft)
                
                // Move para o canto inferior direito e sobe a lateral direita
                borderPath.move(to: bottomRight)
                borderPath.addLine(to: topRight)
        }
        
        // Cria a camada de borda e aplica o path
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = borderWidth
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
