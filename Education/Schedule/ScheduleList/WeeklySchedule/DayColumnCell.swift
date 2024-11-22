//
//  DayColumnCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/09/24.
//

import UIKit

class DayColumnCell: UICollectionViewCell {
    // MARK: - ID and Delegate

    static let identifier = "dayColumnCollectionCell"
    weak var delegate: ScheduleDelegate? {
        didSet {
            reloadCollection()
        }
    }

    // MARK: - Properties
    
    var column: Int?
    
    // MARK: - UI Properties
    
    var dayView: DayView? {
        didSet {
            setupUI()
        }
    }

    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self

        collection.register(WeeklyScheduleCell.self, forCellWithReuseIdentifier: WeeklyScheduleCell.identifier)

        collection.translatesAutoresizingMaskIntoConstraints = false

        return collection
    }()

    private let sectionDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }

    // MARK: - Methods
    
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.collection.reloadData()
        }
    }
}

// MARK: - UI Setup

extension DayColumnCell: ViewCodeProtocol {
    func setupUI() {
        guard let dayView else { return }

        contentView.addSubview(dayView)
        contentView.addSubview(collection)

        dayView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 35 / contentView.frame.height),
            dayView.widthAnchor.constraint(equalTo: dayView.heightAnchor),
            dayView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            collection.topAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 21),
            collection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])

        if dayView.tag < 6 {
            contentView.addSubview(sectionDividerView)

            NSLayoutConstraint.activate([
                sectionDividerView.topAnchor.constraint(equalTo: collection.topAnchor, constant: -6),
                sectionDividerView.widthAnchor.constraint(equalToConstant: 1),
                sectionDividerView.heightAnchor.constraint(equalTo: collection.heightAnchor, constant: 6),
                sectionDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        }
    }
}

// MARK: - CollectionView Data Source and Delegate

extension DayColumnCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return delegate?.getNumberOfItemsIn(column ?? 0) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyScheduleCell.identifier, for: indexPath) as? WeeklyScheduleCell else {
            fatalError("Could not dequeue cell")
        }

        let newIndexPath = IndexPath(row: indexPath.row, section: column ?? 0)
        
        guard let configuredCell = delegate?.getConfiguredScheduleCell(from: cell, at: newIndexPath, isDaily: false) as? WeeklyScheduleCell else {
            return cell
        }

        return configuredCell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: Double = collectionView.frame.width - 4.0
        let height: Double = width * (63 / 147) + 20

        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 11
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let column else { return }

        delegate?.didSelectWeeklySchedule(column: column, row: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}
