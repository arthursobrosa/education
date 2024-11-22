//
//  ScheduleVC+Collection.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayColumnCell.identifier, for: indexPath) as? DayColumnCell else {
            fatalError("Could not dequeue day column cell")
        }
        
        let date = viewModel.daysOfWeek[row]
        let dayView = DayView()

        let dayString = viewModel.dayAbbreviation(date)
        let isToday = viewModel.isToday(date)
        dayView.dayOfWeek = DayOfWeek(day: dayString, isSelected: isToday, isToday: isToday)

        dayView.tag = row
        dayView.delegate = self

        cell.dayView = dayView
        cell.column = row
        cell.delegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 150 / 390
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        7
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
}
