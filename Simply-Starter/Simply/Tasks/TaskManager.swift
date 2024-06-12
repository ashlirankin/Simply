//
//  TaskManager.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class TaskManager: NSObject, ObservableObject {

    @Published private(set) var tasks: [TodoTask] = []
    @Published private(set) var error: PersistenceError?
    
    var shouldPresentAlert: Binding<Bool> {
        return Binding {
            return self.error != nil
        } set: { _ in
            self.error = nil
        }
    }
    
    private let persistenceController: PersistenceController<TodoTask> = PersistenceController()
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = TaskManager()
    
    private override init() {
        super.init()
        
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchTasks()
            }
            .store(in: &cancellables)
    }
    
    func addTask(_ task: TodoTask) {
        do {
            var tasks = try persistenceController.fetch()
            tasks.append(task)
            try persistenceController.save(tasks)
            
            tasks = try persistenceController.fetch()
        } catch {
            self.error = error as? PersistenceError
        }
    }
    
    @discardableResult
    func fetchTasks() -> [TodoTask] {
        do {
            let tasks: [TodoTask] = try persistenceController.fetch()
            self.tasks = tasks
            return tasks
        } catch {
            self.error = error as? PersistenceError
        }
        return []
    }
    
    func markTaskAsComplete(task: TodoTask) {
        do {
            var task = task
            task.isComplete = true
            
            var tasks = tasks
            tasks.removeAll(where: { $0.id == task.id })
            tasks.append(task)

            try persistenceController.save(tasks)
            fetchTasks()
        } catch {
            self.error = error as? PersistenceError
        }
    }
}
