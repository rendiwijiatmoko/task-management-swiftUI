//
//  HomeView.swift
//  TaskManagement
//
//  Created by Rendi Wijiatmoko on 21/04/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // MARK: LazyStack with pined header
            LazyVStack(spacing:15, pinnedViews: [.sectionHeaders]) {
                Section  {
                    // MARK: Current Week View
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskModel.currentWeek, id: \.self) { day in
//                                Text(day.formatted(date: .abbreviated, time:.omitted))
                                VStack(spacing: 10) {
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    // EEE will return day as MON, TUE ... etc
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(Color(.systemBackground))
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
//                                .foregroundColor(taskModel.isToday(date: day) ? .primary : .secondary)
                                .foregroundColor(taskModel.isToday(date: day) ? Color(.systemBackground ) : .secondary)
                                // MARK: Capsule shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        // MARK: Matched geometry effect
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.primary)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    // MARK: Header
    func HeaderView()-> some View {
        HStack(spacing:10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }

        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color(.systemBackground))
    }
    
    // MARK: Task View
    func TasksView()-> some View {
        LazyVStack(spacing: 20) {
            if let tasks = taskModel.filteredTask {
                if tasks.isEmpty {
                    Text("No tasks found!")
                        .font(.system(size: 18))
                        .fontWeight(.light)
                        .offset(y:100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                // MARK: Progress view
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Task
        .onChange(of: taskModel.currentDay) { newValue in
            taskModel.filterTodayTask()
        }
    }
    
    // MARK: Task Card View
    func TaskCardView(task: TaskModel)-> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.date) ? .primary : Color(.clear))
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.primary, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.date) ? 0.7 : 1)
                Rectangle()
                    .fill(.primary)
                    .frame(width:3)
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.title)
                            .font(.title2.bold())
                        
                        Text(task.description)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.date.formatted(date: .omitted, time: .shortened))
                }
                
                if taskModel.isCurrentHour(date: task.date) {
                    // MARK: Team member
                    HStack(spacing:0) {
                        HStack(spacing: -10) {
                            ForEach(["Profile", "Profile"], id:\.self) { user in
                                Image(user)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 45, height: 45)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(.primary, lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()
                    }
                    .padding(.top)
                }
            }
            .padding(taskModel.isCurrentHour(date: task.date) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.date) ? 0 : 10)
            .hLeading()
            .background(
                Color(taskModel.isCurrentHour(date: task.date) ? .secondarySystemBackground : .systemBackground)
                    .cornerRadius(25)
            )
        }
        .hLeading()
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
        HomeView()
            .preferredColorScheme(.light)
    }
}
