//
//  TestPageViewController+TextViewDelegate.swift
//  Education
//
//  Created by Leandro Silva on 09/10/24.
//

import UIKit

extension TestPageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.viewModel.comment != "" {
            textView.text = self.viewModel.comment
            textView.textColor = .systemText
            textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        }
        
        if textView.textColor == UIColor(named: "system-text-40") {
            textView.text = nil
            textView.textColor = .systemText
            textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = String(localized: "description")
            textView.textColor = .systemText40
            textView.font = UIFont(name: Fonts.darkModeOnItalic, size: 16)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor != UIColor.lightGray {
            self.viewModel.comment = textView.text
        }
    }
}
