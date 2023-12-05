//
//  AddTaskView.swift
//  Simply
//
//  Created by Ashli Rankin on 12/5/23.
//

import SwiftUI

struct AddTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var taskText = ""
    @State private var taskDate: Date = .now
    
    var body: some View {
        NavigationView {
            Form  {
                TextField(text: $taskText) {
                    Text("Enter the task you want to complete.")
                }
                
                DatePicker("Date", selection: $taskDate)
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "xmark") {
                        taskDate = .now
                        taskText = ""
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        TaskManager.shared.addTask(TodoTask(title: taskText, createDate: taskDate, executedDate: .now))
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    AddTaskView()
}
