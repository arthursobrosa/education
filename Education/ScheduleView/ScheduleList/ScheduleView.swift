//
//  ScheduleView.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation
import UIKit

class ScheduleView: UIView {
    
    private let viewModel: ScheduleViewModel
    private let daysStackView = UIStackView()
    private let tasksScrollView = UIScrollView()
    private var taskViews = [TaskView]()
    private var dayViews = [UIView]()
    
    private let taskColors: [UIColor] = [.systemIndigo, .systemGreen, .systemOrange, .systemPurple]
    
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupView()
        updateTasks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(daysStackView)
        addSubview(tasksScrollView)
        
        daysStackView.axis = .horizontal
        daysStackView.distribution = .fillEqually
        daysStackView.alignment = .center
        daysStackView.spacing = 4
        
        daysStackView.translatesAutoresizingMaskIntoConstraints = false
        tasksScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            daysStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            daysStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            tasksScrollView.topAnchor.constraint(equalTo: daysStackView.bottomAnchor, constant: 16),
            tasksScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tasksScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tasksScrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        for day in viewModel.daysOfWeek {
            let dayView = createDayView(for: day)
            daysStackView.addArrangedSubview(dayView)
            dayViews.append(dayView)
        }
    }
    
    private func createDayView(for date: Date) -> UIView {
        let view = UIView()
        let dayLabel = UILabel()
        let dateLabel = UILabel()
        
        view.addSubview(dayLabel)
        view.addSubview(dateLabel)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayLabel.text = viewModel.dayAbbreviation(date)
        dateLabel.text = viewModel.dayFormatted(date)
        
        dayLabel.textAlignment = .center
        dateLabel.textAlignment = .center
        
        dayLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        
        let isSelected = viewModel.selectedDay == Calendar.current.component(.weekday, from: date) - 1
        view.backgroundColor = isSelected ? .systemBlue : .clear
        dayLabel.textColor = isSelected ? .white : .label
        dateLabel.textColor = isSelected ? .white : .label
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayViewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        view.tag = Calendar.current.component(.weekday, from: date) - 1
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            dayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        return view
    }
    
    @objc private func dayViewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        viewModel.selectedDay = view.tag
        updateTasks()
        updateDayViews()
    }
    
    private func updateTasks() {
        taskViews.forEach { $0.removeFromSuperview() }
        taskViews = []
        
        let tasks = viewModel.tasks(for: viewModel.selectedDay)
        var lastView: UIView? = nil
        
        for (index, task) in tasks.enumerated() {
            let color = taskColors[index % taskColors.count]
            let taskView = TaskView(task: task, bgColor: color)
            tasksScrollView.addSubview(taskView)
            taskView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                taskView.leadingAnchor.constraint(equalTo: tasksScrollView.leadingAnchor),
                taskView.trailingAnchor.constraint(equalTo: tasksScrollView.trailingAnchor),
                taskView.widthAnchor.constraint(equalTo: tasksScrollView.widthAnchor)
            ])
            
            if let lastView = lastView {
                taskView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 8).isActive = true
            } else {
                taskView.topAnchor.constraint(equalTo: tasksScrollView.topAnchor).isActive = true
            }
            
            lastView = taskView
            taskViews.append(taskView)
        }
        
        lastView?.bottomAnchor.constraint(equalTo: tasksScrollView.bottomAnchor).isActive = true
    }
    
    private func updateDayViews() {
        for (index, dayView) in dayViews.enumerated() {
            let isSelected = viewModel.selectedDay == index
            dayView.backgroundColor = isSelected ? .systemBlue : .clear
            for label in dayView.subviews.compactMap({ $0 as? UILabel }) {
                label.textColor = isSelected ? .white : .label
            }
        }
    }
}

