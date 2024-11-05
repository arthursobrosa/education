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
        layoutIfNeeded()

        // Remover subcamadas anteriores relacionadas às bordas
        layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

        // Criar o caminho arredondado
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))

        // Definir o mask da camada
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask

        // Adicionar borda à camada
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        borderLayer.name = "borderLayer"
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            borderLayer.strokeColor = borderColor.cgColor
        }

        layer.addSublayer(borderLayer)
    }

    func createCurve(on roundedCurveCase: RoundedCurveCase, radius: CGFloat = 0, borderWidth: CGFloat, borderColor: UIColor) {
        // Cria o path manualmente para desenhar as linhas que você precisa
        let arcPath = UIBezierPath()
        let vLinePath = UIBezierPath()
        let hLinePath = UIBezierPath()

        // Define os pontos para desenhar o path
        let bottomLeft = CGPoint(x: bounds.minX, y: bounds.maxY)
        let topLeft = CGPoint(x: bounds.minX, y: bounds.minY)
        let topRight = CGPoint(x: bounds.maxX, y: bounds.minY)
        let bottomRight = CGPoint(x: bounds.maxX, y: bounds.maxY)

        switch roundedCurveCase {
        case .top:
            // Linha esquerda
            vLinePath.move(to: bottomLeft)
            vLinePath.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))

            // Arco no canto superior esquerdo
            arcPath.move(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))
            arcPath.addArc(
                withCenter: CGPoint(x: radius + 0.5, y: topLeft.y + radius + 0.5),
                radius: radius,
                startAngle: .pi,
                endAngle: 3 * .pi / 2,
                clockwise: true
            )

            // Linha de cima
            hLinePath.move(to: CGPoint(x: topLeft.x + radius, y: topLeft.y + 0.5))
            hLinePath.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y + 0.5))

            // Arco no canto superior direito
            arcPath.move(to: CGPoint(x: topRight.x - radius, y: topRight.y))
            arcPath.addArc(
                withCenter: CGPoint(x: topRight.x - radius - 0.5, y: topRight.y + radius + 0.5),
                radius: radius,
                startAngle: 3 * .pi / 2,
                endAngle: 0,
                clockwise: true
            )

            // Linha direita
            vLinePath.move(to: CGPoint(x: topRight.x, y: topLeft.y + radius))
            vLinePath.addLine(to: bottomRight)

        case .bottom:
            // Linha esquerda
            vLinePath.move(to: topLeft)
            vLinePath.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius - 0.5))
                
            // Arco no canto inferior esquerdo
            arcPath.move(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius))
            arcPath.addArc(
                withCenter: CGPoint(x: bottomLeft.x + radius + 0.5, y: bottomLeft.y - radius - 0.5),
                radius: radius,
                startAngle: .pi,
                endAngle: .pi / 2,
                clockwise: false
            )

            // Linha de baixo
            hLinePath.move(to: CGPoint(x: bottomLeft.x + radius + 0.5, y: bottomLeft.y - 0.5))
            hLinePath.addLine(to: CGPoint(x: bottomRight.x - radius - 0.5, y: bottomLeft.y - 0.5))
                
            // Arco no canto inferior direito
            arcPath.move(to: CGPoint(x: bottomRight.x - radius, y: bottomRight.y))
            arcPath.addArc(
                withCenter: CGPoint(x: bottomRight.x - radius - 0.5, y: bottomRight.y - radius - 0.5),
                radius: radius,
                startAngle: .pi / 2,
                endAngle: 0,
                clockwise: false
            )

            // Linha direita
            vLinePath.move(to: CGPoint(x: bottomRight.x, y: bottomRight.y - radius))
            vLinePath.addLine(to: topRight)

        case .laterals:
            // Linha esquerda
            vLinePath.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            vLinePath.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))

            // Linha direita
            vLinePath.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            vLinePath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        }

        // Cria a camada de borda e aplica o path
        let vLineLayer = CAShapeLayer()
        vLineLayer.path = vLinePath.cgPath
        vLineLayer.strokeColor = borderColor.cgColor
        vLineLayer.fillColor = UIColor.clear.cgColor
        vLineLayer.lineWidth = borderWidth
        vLineLayer.frame = bounds
        vLineLayer.name = "vLineLayer"

        let hLineLayer = CAShapeLayer()
        hLineLayer.path = hLinePath.cgPath
        hLineLayer.strokeColor = borderColor.cgColor
        hLineLayer.fillColor = UIColor.clear.cgColor
        hLineLayer.lineWidth = borderWidth / 2
        hLineLayer.frame = bounds
        hLineLayer.name = "hLineLayer"

        let arcLayer = CAShapeLayer()
        arcLayer.path = arcPath.cgPath
        arcLayer.strokeColor = borderColor.cgColor
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.lineWidth = borderWidth / 2
        arcLayer.frame = bounds
        arcLayer.name = "arcLayer"
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            vLineLayer.strokeColor = borderColor.cgColor
            hLineLayer.strokeColor = borderColor.cgColor
            arcLayer.strokeColor = borderColor.cgColor
        }

        // Adiciona a camada de borda na view
        layer.addSublayer(vLineLayer)
        layer.addSublayer(hLineLayer)
        layer.addSublayer(arcLayer)
    }
}

enum RoundedCurveCase {
    case top
    case bottom
    case laterals
}
