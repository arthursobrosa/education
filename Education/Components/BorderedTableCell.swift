//
//  BorderedTableCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class BorderedTableCell: UITableViewCell {
    static let identifier = "borderedCell"
    
    var isConfigured: Bool = false

    func configureCell(tableView: UITableView, forRowAt indexPath: IndexPath) {
        guard !isConfigured else { return }
        
        if responds(to: #selector(getter: UIView.tintColor)) {
            /// cell initial config
            let cornerRadius: CGFloat = bounds.width * (15 / 353)
            let borderWidth: CGFloat = 1.5
            backgroundColor = .systemBackground
            selectionStyle = .none

            /// layer initialization for separator
            let separatorLayer = CAShapeLayer()

            /// depending on the row, a line will drawn or not
            var addLine = false
            
            /// if current row is the first and section only has one row
            if indexPath.row == 0 && tableView.numberOfRows(inSection: indexPath.section) == 1 {
                /// then add a rounded rectangle around its bounds
                roundCorners(corners: .allCorners, radius: cornerRadius * 0.95, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)

            /// if it's the first row but section has more than one row
            } else if indexPath.row == 0 {
                /// then create an arc at the top
                createCurve(on: .top, radius: cornerRadius, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)
                
                /// and a line will need to be created below this row
                addLine = true

            /// if it's the last row of a section with more than one row
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                /// then create an arc at the bottom
                createCurve(on: .bottom, radius: cornerRadius, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)

            /// if it's an inbetween row
            } else {
                /// then create two lines at the sides
                createCurve(on: .laterals, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)
                
                /// and a line will also need to be created below this row
                addLine = true
            }

            /// create separator line for the rows that need to
            if addLine {
                let lineHeight: CGFloat = 1 / UIScreen.main.scale
                let offset = bounds.width / 21.53 /// little offset to imitate native line separator style
                separatorLayer.frame = CGRect(x: bounds.minX + offset, y: bounds.height - lineHeight, width: bounds.width - offset, height: lineHeight)
                separatorLayer.backgroundColor = tableView.separatorColor?.cgColor
                
                /// guarantee separator layer colors are updated correctly both at light and dark mode
                registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
                    separatorLayer.backgroundColor = tableView.separatorColor?.cgColor
                }
            }

            /// create UIView with the same size of the cell and the created layers to it
            let backgroundView = UIView(frame: bounds)
            backgroundView.layer.insertSublayer(separatorLayer, at: 0)
            backgroundView.backgroundColor = .clear

            /// set new background view as cell's background view
            self.backgroundView = backgroundView
        }
    }
    
    func setAccessoryView(_ accessoryView: UIView?) {
        guard let accessoryView else { return }

        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(accessoryView)

        NSLayoutConstraint.activate([
            accessoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            accessoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
