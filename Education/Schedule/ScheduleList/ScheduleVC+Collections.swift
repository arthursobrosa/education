//
//  ScheduleVC+Collections.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isDaily = collectionView.tag == 0
        
        return isDaily ? self.viewModel.schedules.count : 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.getCellFor(collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.getSizeForItemIn(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let isDaily = collectionView.tag == 0
        
        return isDaily ? 11 : 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard collectionView.tag == 1 else { return .zero }
        
        return .init(top: 0, left: 12, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let schedule = self.viewModel.schedules[indexPath.row]
        
        self.coordinator?.showScheduleDetailsModal(schedule: schedule)
    }
    
    // MARK: - Auxiliar Methods
    private func getCellFor(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let isDaily = collectionView.tag == 0
        
        let row = indexPath.row
        
        if isDaily {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else { fatalError("Could not dequeue cell") }

            return self.getConfiguredScheduleCell(from: cell, at: indexPath)
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayColumnCell.identifier, for: indexPath) as? DayColumnCell else {
                fatalError("Could not dequeue cell")
            }
            
            let date = self.viewModel.daysOfWeek[row]
            let dayView = DayView()
            
            let dayString = self.viewModel.dayAbbreviation(date)
            let dateString = self.viewModel.dayFormatted(date)
            let isToday = self.viewModel.isToday(date)
            dayView.dayOfWeek = DayOfWeek(day: dayString, date: dateString, isSelected: isToday, isToday: isToday)
            
            dayView.tag = row
            dayView.delegate = self
            
            cell.dayView = dayView
            cell.column = row
            cell.delegate = self
            
            return cell
        }
    }
    
    private func getSizeForItemIn(_ collectionView: UICollectionView) -> CGSize {
        let isDaily = collectionView.tag == 0
        
        let width = isDaily ? collectionView.frame.width : collectionView.frame.width * (150/390)
        let height = isDaily ? collectionView.frame.width * (68/366) : collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
    func getTimeLabelString(for indexPath: IndexPath, isDaily: Bool) -> NSAttributedString {
        let schedule = isDaily ? self.viewModel.schedules[indexPath.row] : self.viewModel.tasks[indexPath.section][indexPath.row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        let colorName = subject?.unwrappedColor
        
        let color = UIColor(named: colorName ?? "sealBackgroundColor")
        let font: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)
        let startTimeColor: UIColor = (self.traitCollection.userInterfaceStyle == .light ? color?.darker(by: 0.8) : color) ?? .label
        let endTimeColor: UIColor = (self.traitCollection.userInterfaceStyle == .light ? color : color?.darker(by: 0.8)) ?? .label
        
        let attributedString = NSMutableAttributedString()
        let startTimeString = NSAttributedString(string: self.viewModel.getShortTimeString(for: schedule, isStartTime: true), attributes: [.font : font, .foregroundColor : startTimeColor])
        let endTimeString = NSAttributedString(string: self.viewModel.getShortTimeString(for: schedule, isStartTime: false), attributes: [.font : font, .foregroundColor : endTimeColor])
        
        attributedString.append(startTimeString)
        isDaily ? attributedString.append(NSAttributedString(string: " - ", attributes: [.font : font, .foregroundColor : endTimeColor])) : attributedString.append(NSAttributedString(string: "\n", attributes: [.font : font, .foregroundColor : endTimeColor]))
        attributedString.append(endTimeString)
        
        return attributedString
    }
}
