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
        
        self.backgroundColor = .systemBackground
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let row,
              self.numberOfRowsInSection != 0,
              !self.bordersWereSet else { return }
        
        let radius = self.bounds.width * (15/353)
        let borderWidth = self.bounds.width * (1.5/353)
        let borderColor = UIColor.systemGray4
        
        if self.numberOfRowsInSection == 1 {
            self.roundCorners(corners: .allCorners, radius: radius * 0.95, borderWidth: borderWidth, borderColor: borderColor)
        } else {
            if row == 0 {
                self.createCurve(on: .top, radius: radius, borderWidth: borderWidth, borderColor: borderColor, rect: self.bounds)
            } else if row == self.numberOfRowsInSection - 1 {
                self.createCurve(on: .bottom, radius: radius, borderWidth: borderWidth, borderColor: borderColor, rect: self.bounds)
            } else {
                self.createCurve(on: .laterals, borderWidth: borderWidth, borderColor: borderColor, rect: self.bounds)
            }
        }
        
        self.bordersWereSet = true
    }
    
    func setAccessoryView(_ accessoryView: UIView?) {
        guard let accessoryView else { return }
        
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(accessoryView)
        
        NSLayoutConstraint.activate([
            
            accessoryView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17),
            accessoryView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.row = nil
        self.numberOfRowsInSection = 0
    }
}
