//
//  StudyTimeChartCell.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/09/24.
//

import SwiftUI
import UIKit

class StudyTimeChartCell: UITableViewCell {
    static let identifier = "studyTimeChartCell"
    private var hostingController: UIHostingController<StudyTimeChartView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with chartView: StudyTimeChartView) {
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()

        let hostingController = UIHostingController(rootView: chartView)

        contentView.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        self.hostingController = hostingController
    }
}
