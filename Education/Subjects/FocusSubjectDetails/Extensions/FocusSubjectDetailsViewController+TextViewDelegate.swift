//
//  FocusSubjectDetailsView+TextViewDelegate.swift
//  Education
//
//  Created by Leandro Silva on 17/11/24.
//

import UIKit

extension FocusSubjectDetailsViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return focusSubjectDetails.notesView.isEditable
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.textColor = .systemText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .systemText
            focusSubjectDetails.notesView.isEditable = false
        }else {
            viewModel.notes = textView.text
            focusSubjectDetails.showSaveButton()
        }
    }
}
