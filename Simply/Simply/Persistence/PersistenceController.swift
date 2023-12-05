//
//  PersistenceController.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation

@MainActor
final class PersistenceController {
    
    private let fileManager: FileManager = FileManager.default
    
    func writeItem<T: Codable>(at path: URL, _ item: T) throws {
        guard isValidDirectory(path) else {
            throw PersistenceError.directoryCreationFailed
        }
        var items: [T] = try readAllItems(at: path)
        items.append(item)
        let data = try JSONEncoder().encode(items)
        try data.write(to: path)
    }
    
    func readAllItems<T: Codable>(at path: URL) throws -> [T] {
        guard let data = fileManager.contents(atPath: path.path()) else{
            throw PersistenceError.noDataAvailable
        }
        guard let items = try? JSONDecoder().decode([T].self, from: data) else {
            throw PersistenceError.decodingError
        }
        return items
    }
    
    func readItem<T: Codable & Identifiable>(at path: URL, with identifier: any Hashable) throws -> T? {
        guard let data = fileManager.contents(atPath: path.path()) else {
            throw PersistenceError.noDataAvailable
        }
        guard let elements: [T] = try? JSONDecoder().decode([T].self, from: data) else {
            throw PersistenceError.decodingError
        }
        let element = elements.filter { element in element.id == identifier as? T.ID }.first
        return element
    }
    
    func removeItem<T: Codable & Identifiable>(at path: URL, with identifier: any Hashable, of type: T.Type) throws {
        var items: [T] = try readAllItems(at: path)
        items.removeAll(where: { $0.id == identifier as! T.ID } )

        try items.forEach { item in
            try writeItem(at: path, item)
        }
    }
    
    private func isValidDirectory(_ path: URL) -> Bool {
        if !fileManager.fileExists(atPath: path.path()) {
            do {
                try fileManager.createDirectory(at: .appGroupContainerURL, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                return false
            }
        }
        return false
    }
}
