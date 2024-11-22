//
//  FocusSubjectDetailsView+TextViewDelegate.swift
//  Education
//
//  Created by Leandro Silva on 17/11/24.
//

import UIKit

extension FocusSubjectDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        focusSubjectDetails.changeNotesPlaceholderVisibility(isShowing: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        viewModel.currentNotes = text
        
        if text.isEmpty {
            focusSubjectDetails.changeNotesPlaceholderVisibility(isShowing: true)
        }
    }
}
