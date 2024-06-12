//
//  PersistenceController.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation

@MainActor
final class PersistenceController<T: Codable & Identifiable> {
    
    private static var fileExists: Bool {
        FileManager.default.fileExists(atPath: URL.tasksEndpoint.path())
    }
    
    func fetch() throws -> [T] {
        guard Self.fileExists else {
            return []
        }
        let jsonData = try Data(contentsOf: URL.tasksEndpoint)
        let decoder = JSONDecoder.apiDecoder
        return try decoder.decode([T].self, from: jsonData)
    }
    
    func save(_ items: [T]) throws -> Void {
        let data = try JSONEncoder.apiEncoder.encode(items)
        try data.write(to: URL.tasksEndpoint, options: [.atomicWrite])
    }
    
    func remove(_ items: [T]) throws {
        var localItems = try fetch()
        localItems.removeAll { item in
            items.contains(where: { $0.id == item.id })
        }
        try save(localItems)
    }
}
