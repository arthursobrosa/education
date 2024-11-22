//
//  ShowingSubjectDetails.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import Foundation

protocol ShowingSubjectDetails: AnyObject {
    func showSubjectDetails(subject: Subject?, studyTimeViewModel: StudyTimeViewModel)
}
