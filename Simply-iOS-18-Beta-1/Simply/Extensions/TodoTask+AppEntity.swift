//
//  TodoTask+AppEntity.swift
//  Simply
//
//  Created by Ashli Rankin on 6/12/24.
//

import Foundation
import AppIntents

extension TodoTask: AppEntity, @unchecked Sendable {

    struct TaskQuery: EntityQuery {
        @IntentParameterDependency<CompleteTaskIntent>(
                \.$date
            )
            var completeTaskIntent

            private let taskManager: TaskManager = TaskManager.shared
            private let calendar = Calendar.autoupdatingCurrent

            func entities(for identifiers: [UUID]) async throws -> [TodoTask] {
                return try await suggestedEntities().filter { task in
                    return identifiers.contains(task.id)
                }
            }

            func suggestedEntities() async throws -> [TodoTask] {
                guard let selectedDate = completeTaskIntent?.date else {
                    return []
                }

                let startDate: Date = calendar.startOfDay(for: selectedDate)
                let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!

                let foundTasks: [TodoTask] = await taskManager.fetchTasks()
                let filteredTasks: [TodoTask] = foundTasks.filter { task in
                    task.createDate >= startDate &&  task.createDate < endDate && !task.isComplete
                }
                return filteredTasks
            }
    }

    var displayRepresentation: DisplayRepresentation {
        return .init(stringLiteral: "\(title)")
    }

    static var defaultQuery: TaskQuery = TaskQuery()

    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "Task")
}
