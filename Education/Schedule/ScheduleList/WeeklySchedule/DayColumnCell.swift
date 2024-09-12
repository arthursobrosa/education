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
            self.reloadCollection()
        }
    }
    
    var dayView: DayView? {
        didSet {
            self.setupUI()
        }
    }
    
    var column: Int?
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.identifier)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    private let sectionDividerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.collection.reloadData()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

private extension DayColumnCell  {
    func setupUI() {
        guard let dayView else { return }
        
        self.contentView.addSubview(dayView)
        self.contentView.addSubview(collection)
        
        dayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            dayView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: (58/self.contentView.frame.height)),
            dayView.widthAnchor.constraint(equalTo: dayView.heightAnchor, multiplier: (35/58)),
            dayView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            
            collection.topAnchor.constraint(equalTo: dayView.bottomAnchor, constant: 18),
            collection.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
        ])
        
        if dayView.tag < 6 {
            self.contentView.addSubview(sectionDividerView)
            
            NSLayoutConstraint.activate([
                sectionDividerView.topAnchor.constraint(equalTo: collection.topAnchor, constant: -6),
                sectionDividerView.widthAnchor.constraint(equalToConstant: 1),
                sectionDividerView.heightAnchor.constraint(equalTo: collection.heightAnchor, constant: 6),
                sectionDividerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
        }
    }
}

extension DayColumnCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.getNumberOfItemsIn(self.column ?? 0) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
            fatalError("Could not dequeue cell")
        }
        
        let newIndexPath = IndexPath(row: indexPath.row, section: self.column ?? 0)
        
        return self.delegate?.getConfiguredScheduleCell(from: cell, at: newIndexPath, isDaily: false) ?? cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: Double = collectionView.frame.width
        let height: Double = width * (63/147)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectWeeklySchedule(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}
