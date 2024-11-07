//
//  CustomChart.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import UIKit

class CustomChart: UIView {
    weak var delegate: ThemePageDelegate?

    private var limit: Int

    private var rawData = [any Comparable]()
    private var filteredData = [any Comparable]()
    private var dataSize = Int()

    private let percentageIndexesStack: UIView = {
        let stack = UIView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let percentagesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 12)
        label.textColor = .bluePicker
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var percentagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground

        collection.dataSource = self
        collection.delegate = self
        collection.register(PercentageCell.self, forCellWithReuseIdentifier: PercentageCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false

        return collection
    }()

    private let dayIndicatorStack: UIView = {
        let stack = UIView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(frame: CGRect = .zero, limit: Int) {
        self.limit = limit

        super.init(frame: frame)

        setupUI()
        setPercentageIndexesStack()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setPercentageIndexesStack() {
        let percentageIndexes = ["100%", "50%", "0%"]

        for (index, percentageIndex) in percentageIndexes.enumerated() {
            let label = UILabel()
            label.text = percentageIndex
            label.font = UIFont(name: Fonts.darkModeOnMedium, size: 13)
            label.textColor = .label.withAlphaComponent(0.8)
            label.translatesAutoresizingMaskIntoConstraints = false

            percentageIndexesStack.addSubview(label)

            var constraint = NSLayoutConstraint()

            switch index {
            case 0:
                constraint = label.topAnchor.constraint(equalTo: percentageIndexesStack.topAnchor)
            case 1:
                constraint = label.centerYAnchor.constraint(equalTo: percentageIndexesStack.centerYAnchor)
            case 2:
                constraint = label.bottomAnchor.constraint(equalTo: percentageIndexesStack.bottomAnchor)
            default:
                break
            }

            constraint.isActive = true
            label.centerXAnchor.constraint(equalTo: percentageIndexesStack.centerXAnchor).isActive = true
        }
    }

    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.percentagesCollectionView.reloadData()
        }
    }

    func changeLimit(to limit: Int) {
        self.limit = limit
        filterData()
        reloadCollection()
    }

    func setData<T, U, V>(_ data: [T], sorter keyPath: KeyPath<T, U>, mapTo resultKeyPath: KeyPath<T, V>, ascending: Bool = true) where U: Comparable, V: Comparable {
        dataSize = 0
        rawData = []
        filteredData = []

        let comparison: (T, T) -> Bool = ascending ? {
            $0[keyPath: keyPath] < $1[keyPath: keyPath]
        } : {
            $0[keyPath: keyPath] > $1[keyPath: keyPath]
        }

        let sortedData = data.sorted(by: comparison).map { $0[keyPath: resultKeyPath] }

        rawData = sortedData
        dataSize = data.count

        filterData()
    }

    private func filterData() {
        filteredData = limit <= dataSize ?
            Array(rawData.prefix(limit)) :
            rawData
    }
}

extension CustomChart: ViewCodeProtocol {
    func setupUI() {
        addSubview(percentageIndexesStack)
        addSubview(percentagesContainerView)
        addSubview(percentagesCollectionView)
        addSubview(dividerView)

        NSLayoutConstraint.activate([
            percentageIndexesStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 24 / 344),
            percentageIndexesStack.heightAnchor.constraint(equalTo: percentageIndexesStack.widthAnchor, multiplier: 148 / 24),
            percentageIndexesStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            percentageIndexesStack.leadingAnchor.constraint(equalTo: leadingAnchor),

            percentagesContainerView.heightAnchor.constraint(equalTo: percentagesContainerView.widthAnchor, multiplier: 132 / 288),
            percentagesContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            percentagesContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21),
            percentagesContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            percentagesCollectionView.widthAnchor.constraint(equalTo: percentagesContainerView.widthAnchor),
            percentagesCollectionView.heightAnchor.constraint(equalTo: percentagesContainerView.heightAnchor),
            percentagesCollectionView.centerXAnchor.constraint(equalTo: percentagesContainerView.centerXAnchor),
            percentagesCollectionView.centerYAnchor.constraint(equalTo: percentagesContainerView.centerYAnchor),

            dividerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 309 / 344),
            dividerView.heightAnchor.constraint(equalTo: dividerView.widthAnchor, multiplier: 2 / 309),
            dividerView.topAnchor.constraint(equalTo: percentagesContainerView.bottomAnchor, constant: 2),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }

    private func layoutDateLabel(at xPosition: CGFloat) {
        removeDateLabel()
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: xPosition + 36),
        ])
    }
    
    private func removeDateLabel() {
        dateLabel.removeFromSuperview()
    }
}

extension CustomChart: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PercentageCell else {
            fatalError("Could not dequeue cell")
        }
        
        guard !cell.isEmpty else { return }
        
        guard !cell.isShowingDateLabel else {
            cell.isShowingDateLabel = false
            removeDateLabel()
            return
        }
        
        layoutDateLabel(at: cell.center.x)
        dateLabel.text = delegate?.getSelectedTestDateString(for: indexPath.row)
        
        cell.isShowingDateLabel = true
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return limit
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PercentageCell.identifier, for: indexPath) as? PercentageCell else {
            fatalError("Could not dequeue cell")
        }

        var percentage = Double()
        var isEmpty = true

        if row < filteredData.count,
           let percent = filteredData[row] as? Double {
            
            isEmpty = false
            percentage = percent
        }

        cell.percentage = percentage
        cell.isEmpty = isEmpty

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let numberOfColumns = limit + (limit - 1)

        let size = CGSize(width: collectionView.bounds.width / Double(numberOfColumns), height: collectionView.bounds.height)

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        let numberOfColumns = limit + (limit - 1)

        let lineSpacing = collectionView.bounds.width / Double(numberOfColumns)

        setDayIndicatorStack(for: lineSpacing)

        return lineSpacing
    }

    private func setDayIndicatorStack(for lineSpacing: Double) {
        for subview in dayIndicatorStack.subviews {
            subview.removeFromSuperview()
        }

        dayIndicatorStack.removeFromSuperview()

        addSubview(dayIndicatorStack)

        NSLayoutConstraint.activate([
            dayIndicatorStack.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 10),
            dayIndicatorStack.centerXAnchor.constraint(equalTo: percentagesContainerView.centerXAnchor),
            dayIndicatorStack.widthAnchor.constraint(equalTo: percentagesContainerView.widthAnchor, constant: -lineSpacing / 4),
        ])

        var indicators = [Int]()

        switch limit {
        case 10:
            indicators = [1, 5, 10]
        case 15:
            indicators = [1, 5, 10, 15]
        case 20:
            indicators = [1, 5, 10, 15, 20]
        default:
            break
        }

        for (index, indicator) in indicators.enumerated() {
            var spacing = Double()

            if index > 0 {
                spacing = Double(indicators[index] - indicators[index - 1]) * lineSpacing * 2
                let addition: Double = indicator == 10 ? lineSpacing / 4 : 0
                spacing -= addition
            }

            let label = UILabel()
            label.text = "\(indicator)"
            label.font = UIFont(name: Fonts.darkModeOnMedium, size: 13)
            label.textColor = .label.withAlphaComponent(0.8)
            label.translatesAutoresizingMaskIntoConstraints = false

            dayIndicatorStack.addSubview(label)

            let previousView = index == 0 ? dayIndicatorStack : dayIndicatorStack.subviews[index - 1]

            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: dayIndicatorStack.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: previousView.leadingAnchor, constant: spacing),
            ])
        }
    }
}

class PercentageCell: UICollectionViewCell {
    static let identifier = "percentageCell"

    var percentage: Double? {
        didSet {
            guard let _ = percentage else { return }

            setupUI()
        }
    }

    override var isSelected: Bool {
        didSet {
            changeColors(isFocused: isSelected)
        }
    }

    var isEmpty: Bool = false {
        didSet {
            let alpha: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.15 : 0.06
            percentageBackgroundView.backgroundColor = isEmpty ? .clear : .label.withAlphaComponent(alpha)
            percentageView.backgroundColor = isEmpty ? .clear : UIColor(named: "bluePicker")
        }
    }
    
    var isShowingDateLabel: Bool = false {
        didSet {
            changeColors(isFocused: isShowingDateLabel)
        }
    }

    private let percentageBackgroundView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let percentageView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        percentageBackgroundView.layer.cornerRadius = bounds.width * (10 / 22)
        percentageView.layer.cornerRadius = percentageBackgroundView.layer.cornerRadius
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }

        percentage = nil
        isEmpty = false
    }
    
    private func changeColors(isFocused: Bool) {
        guard !isEmpty else { return }

        let lighterBy = 0.6

        let alpha: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0.15 : 0.06
        percentageBackgroundView.backgroundColor = isFocused ? .label.withAlphaComponent(alpha * lighterBy) : .label.withAlphaComponent(alpha)
        percentageView.backgroundColor = isFocused ? .bluePicker.withAlphaComponent(1 * lighterBy) : .bluePicker
    }
}

extension PercentageCell: ViewCodeProtocol {
    func setupUI() {
        guard let percentage else { return }

        contentView.addSubview(percentageBackgroundView)
        contentView.addSubview(percentageView)

        NSLayoutConstraint.activate([
            percentageBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            percentageBackgroundView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            percentageBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            percentageBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            percentageView.widthAnchor.constraint(equalTo: percentageBackgroundView.widthAnchor),
            percentageView.heightAnchor.constraint(equalTo: percentageBackgroundView.heightAnchor, multiplier: percentage),
            percentageView.centerXAnchor.constraint(equalTo: percentageBackgroundView.centerXAnchor),
            percentageView.bottomAnchor.constraint(equalTo: percentageBackgroundView.bottomAnchor),
        ])
    }
}
