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
            textView.textColor = UIColor.black
            textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        }
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = String(localized: "description")
            textView.textColor = UIColor.lightGray
            textView.font = UIFont.italicSystemFont(ofSize: 16)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor != UIColor.lightGray {
            self.viewModel.comment = textView.text
        }
    }
}
