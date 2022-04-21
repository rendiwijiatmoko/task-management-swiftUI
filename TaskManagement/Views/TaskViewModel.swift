//
//  TaskViewModel.swift
//  TaskManagement
//
//  Created by Rendi Wijiatmoko on 21/04/22.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    // some task
    @Published var storeTasks: [TaskModel] = [
        TaskModel(title: "Meeting", description: "Disscus team task for today", date: .init(timeIntervalSince1970: 1650474722)),
        TaskModel(title: "Meeting Manager", description: "Updating Task", date: .init(timeIntervalSince1970: 1650561122)),
        TaskModel(title: "Sprint", description: "Updating Weekly sprint", date: .init(timeIntervalSince1970: 1650561122)),
        TaskModel(title: "Reminder", description: "Update timesheet", date: Date()),
    ]
    
    // MARK: Current Week days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Task
    @Published var filteredTask: [TaskModel]?
    
    // MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTask()
    }
    
    // MARK: Filter Today Tasks
    func filterTodayTask() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storeTasks.filter {
                return calendar.isDate($0.date, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.date <  task1.date
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTask = filtered
                }
            }
        }
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
        
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current date is today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking if the current hour is task hour
    func isCurrentHour(date: Date)-> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
