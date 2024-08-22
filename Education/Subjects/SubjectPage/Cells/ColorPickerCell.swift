//
//  ColorPickerCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class ColorPickerCell: UITableViewCell {
    
    static let identifier = "colorPickerCell"
    
    // Label para o texto "Cor"
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "color")
        return label
    }()
    
    // UIView para a bolinha colorida
    private let colorCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "blueSkyPicker") // Cor inicial, pode ser mudada depois
        view.layer.cornerRadius = 10 // Tornar a UIView redonda
        view.layer.masksToBounds = true
        return view
    }()
    
    // Método de inicialização
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // Configura a célula e adiciona os subviews
    private func setupViews() {
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCircleView)
        
        // Configura as constraints
        NSLayoutConstraint.activate([
            // Constraints da label "Cor"
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Constraints da bolinha colorida
            colorCircleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircleView.widthAnchor.constraint(equalToConstant: 20), // Largura da bolinha
            colorCircleView.heightAnchor.constraint(equalToConstant: 20), // Altura da bolinha
        ])
    }
    
    // Método para configurar a cor da bolinha
    func configure(with color: UIColor) {
        colorCircleView.backgroundColor = color
    }
}
