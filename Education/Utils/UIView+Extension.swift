//
//  UIView+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        // Certifique-se de que os bounds estão definidos
        self.layoutIfNeeded()

        // Remover subcamadas anteriores relacionadas às bordas
        self.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

        // Criar o caminho arredondado
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius , height: radius))
        
        // Definir o mask da camada
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        // Adicionar borda à camada
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
        let borderPathArc = UIBezierPath()
        let borderPathLine = UIBezierPath()
        
        var lineWidth = borderWidth
        
        // Define os pontos para desenhar o path
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        switch roundedCurveCase {
            case .top:
                borderPathLine.move(to: bottomLeft)
                
                borderPathLine.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))
            
                borderPathArc.move(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))
                borderPathArc.addArc(withCenter: CGPoint(x:  radius + 0.5, y: topLeft.y + radius + 0.5),
                                  radius: radius,
                                  startAngle: .pi,
                                  endAngle: 3 * .pi / 2,
                                  clockwise: true)
            
                borderPathLine.move(to: CGPoint(x: topLeft.x + radius, y: topLeft.y))
                
                
                borderPathLine.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y))
            
                borderPathArc.move(to: CGPoint(x: topRight.x - radius, y: topRight.y))
                borderPathArc.addArc(withCenter: CGPoint(x: topRight.x - radius - 0.5, y: topRight.y + radius + 0.5),
                                  radius: radius,
                                  startAngle: 3 * .pi / 2,
                                  endAngle: 0,
                                  clockwise: true)
                
                borderPathLine.move(to: CGPoint(x: topRight.x , y: topLeft.y + radius))
            
                borderPathLine.addLine(to: bottomRight)
            
            case .bottom:
                // Linha esquerda
                borderPathLine.move(to: topLeft)
                borderPathLine.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius - 0.5))
                
                // Linha de baixo
                borderPathLine.move(to: CGPoint(x: bottomLeft.x + radius + 0.5, y: bottomLeft.y))
                borderPathLine.addLine(to: CGPoint(x: bottomRight.x - radius - 0.5, y: bottomLeft.y))
                
                // Linha direita
                borderPathLine.move(to: CGPoint(x: bottomRight.x , y: bottomRight.y - radius))
                borderPathLine.addLine(to: topRight)
                
                borderPathArc.move(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius))
                borderPathArc.addArc(withCenter: CGPoint(x: bottomLeft.x + radius + 0.5, y: bottomLeft.y - radius - 0.5),
                                  radius: radius,
                                  startAngle: .pi,
                                  endAngle: .pi / 2,
                                  clockwise: false)
                
                borderPathArc.move(to: CGPoint(x: bottomRight.x - radius, y: bottomRight.y))
                borderPathArc.addArc(withCenter: CGPoint(x: bottomRight.x - radius - 0.5, y: bottomRight.y - radius - 0.5),
                                  radius: radius,
                                  startAngle: .pi / 2,
                                  endAngle: 0,
                                  clockwise: false)
                
            case .laterals:
                let xOffset = borderWidth * (0.6/2.5)
                let correctedRect = CGRect(x: self.bounds.origin.x + xOffset, y: self.bounds.origin.y, width: self.bounds.width - xOffset * 2, height: self.bounds.height)
                
                lineWidth = xOffset * 2
                
                // Começa no canto superior esquerdo e desce a lateral esquerda
                borderPathLine.move(to: CGPoint(x: correctedRect.minX, y: correctedRect.minY))
                borderPathLine.addLine(to: CGPoint(x: correctedRect.minX, y: correctedRect.maxY))
                
                // Move para o canto inferior direito e sobe a lateral direita
                borderPathLine.move(to: CGPoint(x: correctedRect.maxX, y: correctedRect.minY))
                borderPathLine.addLine(to: CGPoint(x: correctedRect.maxX, y: correctedRect.maxY))
        }
        
        // Cria a camada de borda e aplica o path
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPathArc.cgPath
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = lineWidth / 2
        borderLayer.frame = self.bounds
        
        let borderLayer2 = CAShapeLayer()
        borderLayer2.path = borderPathLine.cgPath
        borderLayer2.strokeColor = borderColor.cgColor
        borderLayer2.fillColor = UIColor.clear.cgColor
        borderLayer2.lineWidth = lineWidth
        borderLayer2.frame = self.bounds
        
        // Adiciona a camada de borda na view
        self.layer.addSublayer(borderLayer)
        self.layer.addSublayer(borderLayer2)
    }
}

enum RoundedCurveCase {
    case top
    case bottom
    case laterals
}
