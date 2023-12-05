//
//  TodoListView.swift
//  Simply
//
//  Created by Ashli Rankin on 12/5/23.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var taskManager: TaskManager = .shared
    
    @State private var shouldShowAddView = false
    
    private static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Group {
                List(taskManager.tasks, id: \.id) { task in
                    Button {
                        taskManager.markTaskAsCompleteIfNeeded(task)
                    } label: {
                        HStack {
                            Image(systemName: task.isComplete ? "multiply.square" : "square")
                            VStack(alignment: .leading) {
                                Text(task.title)
                                   
                                Text(task.createDate, formatter: Self.taskDateFormat)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .strikethrough(task.isComplete)
                            }
                            .strikethrough(task.isComplete)
                        }
                    }
                }
            }
            .navigationTitle("TO-DOs")
            .toolbar {
                Button("", systemImage: "plus") {
                    shouldShowAddView = true
                }
            }
        }
        .sheet(isPresented: $shouldShowAddView) {
            AddTaskView(taskManager: taskManager)
        }
    }
}

#Preview {
    TodoListView()
}
