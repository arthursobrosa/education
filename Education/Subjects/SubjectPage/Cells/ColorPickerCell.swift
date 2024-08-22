//
//  ColorPickerCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import UIKit

class ColorPickerCell: UITableViewCell {
    static let identifier = "colorPickerCell"
    
    var color: String? {
        didSet {
            guard let color else { return }
            
            self.colorCircleView.backgroundColor = UIColor(named: color)
        }
    }
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "color")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let colorCircleView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ColorPickerCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(colorLabel)
        self.contentView.addSubview(colorCircleView)
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            colorCircleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircleView.widthAnchor.constraint(equalToConstant: 20), // Largura da bolinha
            colorCircleView.heightAnchor.constraint(equalToConstant: 20), // Altura da bolinha
        ])
    }
}
