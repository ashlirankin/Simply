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
    
    private let persistenceController: PersistenceController = PersistenceController()
    
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
            try persistenceController.writeItem(at: .tasksPath, task)
            tasks = try persistenceController.readAllItems(at: .tasksPath)
        } catch {
            self.error = error as? PersistenceError
        }
    }
    
    @discardableResult
    func fetchTasks() -> [TodoTask] {
        do {
            let tasks: [TodoTask] = try persistenceController.readAllItems(at: .tasksPath)
            self.tasks = tasks
            return tasks
        } catch {
            self.error = error as? PersistenceError
        }
        return []
    }
    
    @MainActor
    func markTaskAsComplete(task: TodoTask) {
        do {
            var localTask = task
            localTask.isComplete = true
            
            var tasks = tasks
            tasks.removeAll(where: { $0.id == task.id })
            tasks.append(localTask)
            
            try persistenceController.writeItems(at: .tasksPath, tasks)
            fetchTasks()
        } catch {
            self.error = error as? PersistenceError
        }
    }
}
