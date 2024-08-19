//
//  ScheduleViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

// MARK: - Schedule
protocol ScheduleDelegate: AnyObject {
    func setPicker(_ picker: UIStackView)
    func createAcitivityTapped()
    func startAcitivityTapped()
}

extension ScheduleViewController: ScheduleDelegate {
    func setPicker(_ picker: UIStackView) {
        let dates = self.viewModel.daysOfWeek
        
        for (index, date) in dates.enumerated() {
            let dayView = DayView()
            
            let dayString = self.viewModel.dayAbbreviation(date)
            let dateString = self.viewModel.dayFormatted(date)
            let isSelected = self.viewModel.selectedDay == Calendar.current.component(.weekday, from: date) - 1
            let isToday = self.viewModel.selectedDay == Calendar.current.component(.weekday, from: date) - 1
            dayView.dayOfWeek = DayOfWeek(day: dayString, date: dateString, isSelected: isSelected, isToday: isToday)
            
            dayView.tag = index
            dayView.delegate = self
            
            picker.addArrangedSubview(dayView)
        }
    }
    
    func createAcitivityTapped() {
        self.dismissButtons()
        self.coordinator?.showScheduleDetails(schedule: nil, selectedDay: self.viewModel.selectedDay)
    }
    
    func startAcitivityTapped() {
        self.dismissButtons()
        self.coordinator?.showFocusImediate()
    }
}

// MARK: - Day
protocol DayDelegate: AnyObject {
    func dayTapped(_ dayView: DayView)
}

extension ScheduleViewController: DayDelegate {
    func dayTapped(_ dayView: DayView) {
        self.unselectDays()
        
        guard let dayOfWeek = dayView.dayOfWeek else { return }
        
        dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
        self.viewModel.selectedDay = dayView.tag
        
        if(self.scheduleView.viewModeSelector.selectedSegmentIndex == 1){
            didSelectDailyMode()
            self.scheduleView.viewModeSelector.selectedSegmentIndex = 0
        }
        
        
        self.loadSchedules()
    }
}

// MARK: - Play Button
protocol ScheduleButtonDelegate: AnyObject {
    func activityButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?)
}

extension ScheduleViewController: ScheduleButtonDelegate {
    func activityButtonTapped(at indexPath: IndexPath?, withColor color: UIColor?) {
        guard let indexPath else { return }
        
        let row = indexPath.row
        
        let schedule = self.viewModel.schedules[row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        
        let newFocusSessionModel = FocusSessionModel(subject: subject, blocksApps: schedule.blocksApps, isAlarmOn: schedule.imediateAlarm, color: color)
        
        self.coordinator?.showScheduleNotification(schedule: schedule)
    }
}

protocol ViewModeSelectorDelegate: AnyObject {
    func didSelectDailyModeToday()
    func didSelectWeeklyMode()
}

extension ScheduleViewController: ViewModeSelectorDelegate {
    func didSelectDailyMode() {
        self.scheduleView.tableView.isHidden = false
        self.scheduleView.collectionViews.isHidden = true
    }
    
    func didSelectDailyModeToday() {
        self.unselectDays()
        self.selectToday()
        self.scheduleView.tableView.isHidden = false
        self.scheduleView.collectionViews.isHidden = true
        self.loadSchedules()
        self.scheduleView.tableView.reloadData()
    }
    
    func didSelectWeeklyMode() {
        self.unselectDays()
        self.scheduleView.tableView.isHidden = true
        self.scheduleView.collectionViews.isHidden = false
    }
    
    func firstThreeLetters(of text: String) -> String {
        return String(text.prefix(3))
    }
    
    
}


// MARK: - UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(viewModel.tasks[section].count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.tasks[indexPath.section].isEmpty {
            
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as! EmptyCell
            return emptyCell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            
            let task = viewModel.tasks[indexPath.section][indexPath.item]
            
            let subject = self.viewModel.getSubject(fromSchedule: task)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            cell.configure(with: firstThreeLetters(of: subject?.unwrappedName ?? ""), startTime: formatter.string(from: task.unwrappedStartTime), endTime: formatter.string(from: task.unwrappedEndTime), bgColor: subject?.unwrappedColor ?? "")
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !viewModel.tasks[indexPath.section].isEmpty {
            let task = viewModel.tasks[indexPath.section][indexPath.item]
            let subject = self.viewModel.getSubject(fromSchedule: task)
            let subjectName = subject?.unwrappedName
            
            self.coordinator?.showScheduleDetails(title: subjectName, schedule: task, selectedDay: indexPath.section)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let numberOfSections = CGFloat(7)
        let itemWidth = (totalWidth - 29) / numberOfSections
        return CGSize(width: itemWidth, height: 67)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfSections = collectionView.numberOfSections
        let leftInset: CGFloat = section == 0 ? 2 : 2
        let rightInset: CGFloat = section == numberOfSections - 1 ? 0 : 2
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 4, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class TaskCell: UICollectionViewCell {
    static let identifier = "TaskCell"
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(subjectLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeLabel2)
        
        NSLayoutConstraint.activate([
            subjectLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 3),
            
            timeLabel2.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeLabel2.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0),
            timeLabel2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with subject: String, startTime: String, endTime: String, bgColor: String) {
        subjectLabel.text = subject
        timeLabel.text = startTime
        timeLabel2.text = endTime
        contentView.backgroundColor = UIColor(named: bgColor)
    }
}

class EmptyCell: UICollectionViewCell {
    static let identifier = "EmptyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
