//
//  PaddedTextField.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

open class PaddedTextField: UITextField {
    public var textInsets = UIEdgeInsets.zero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: textInsets))
    }
}
