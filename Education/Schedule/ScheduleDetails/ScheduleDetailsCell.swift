//
//  ScheduleDetailsCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ScheduleDetailsCell: UITableViewCell {
    static let identifier = DefaultCell.identifier
    
    var indexPath: IndexPath?
    
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
        
        guard let indexPath,
              !self.bordersWereSet else { return }
        
        let section = indexPath.section
        let row = indexPath.row
        
        let radius = self.bounds.width * (14/353)
        let borderWidth = self.bounds.width * (2.5/353)
        let borderColor = UIColor.secondaryLabel
        
        let correctedValue = self.bounds.height * (10/44)
        
        let correctedRect = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y - correctedValue, width: self.bounds.width, height: self.bounds.height + correctedValue)
        
        let xOffset = self.bounds.width * (0.6/353)
        let otherCorrectedRect = CGRect(x: self.bounds.origin.x + xOffset, y: self.bounds.origin.y, width: self.bounds.width - xOffset * 2, height: self.bounds.height)
        
        switch section {
            case 0:
                switch row {
                    case 0:
                        self.createRoundedCurve(on: .top, radius: 10, borderWidth: borderWidth, borderColor: borderColor, rect: self.bounds)
                    case 1:
                        self.createRoundedCurve(on: .laterals, radius: 0, borderWidth: xOffset * 2, borderColor: borderColor, rect: otherCorrectedRect)
                    case 2:
                        self.createRoundedCurve(on: .bottom, radius: 10, borderWidth: borderWidth, borderColor: borderColor, rect: correctedRect)
                    default:
                        break
                }
            case 1:
                switch row {
                    case 0:
                        self.createRoundedCurve(on: .top, radius: 10, borderWidth: borderWidth, borderColor: borderColor, rect: self.bounds)
                    case 1:
                        self.createRoundedCurve(on: .bottom, radius: 10, borderWidth: borderWidth, borderColor: borderColor, rect: correctedRect)
                    default:
                        break
                }
            default:
                self.roundCorners(corners: .allCorners, radius: radius, borderWidth: borderWidth, borderColor: borderColor)
        }
        
        self.bordersWereSet = true
    }
}
