//
//  ScheduleVC+TableView.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/11/24.
//

import UIKit

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.schedules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyScheduleCell.identifier, for: indexPath) as? DailyScheduleCell else {
            fatalError("Could not dequeue cell")
        }
        
        cell.selectionStyle = .none
        
        guard let configuredCell = getConfiguredScheduleCell(from: cell, at: indexPath, isDaily: true) as? DailyScheduleCell else {
            return cell
        }

        return configuredCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.width * 68 / 366
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        11
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = viewModel.schedules[indexPath.section]
        coordinator?.showScheduleDetailsModal(schedule: schedule)
    }
}
