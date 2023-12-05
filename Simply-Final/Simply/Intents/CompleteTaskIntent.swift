//
//  CompleteTaskIntent.swift
//  Simply
//
//  Created by Ashli Rankin on 12/5/23.
//

import Foundation
import AppIntents
import SwiftUI

struct CompleteTaskIntent: AppIntent {

    @Parameter(title: "Date")
    var date: Date
    
    @Parameter(title: "Task")
    private var task: TodoTask

    static var title: LocalizedStringResource = "Complete Task"
    
    private var taskManager = TaskManager.shared
    
    private var successConfirmationView: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
                .imageScale(.large)
                .font(.largeTitle)
            Text("Task Completed")
        }
    }
    
    @MainActor
    func perform() async throws -> some ShowsSnippetView {
        taskManager.markTaskAsComplete(task: task)
        return .result(view: successConfirmationView)
    }
}
