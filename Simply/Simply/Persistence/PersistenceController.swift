//
//  PersistenceController.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation

@MainActor
final class PersistenceController {
    
    static let shared = PersistenceController()
    
    private let fileManager: FileManager = FileManager.default
    private let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tasks1")!
    
    private init() {}
    
    func writeItem<T: Codable>(at path: URL, _ item: T) throws {
        if !fileManager.fileExists(atPath: path.path()) {
            do {
                try fileManager.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
            }
        }

        do {
            var items: [T] = try readAllItems(at: path)
            items.append(item)
            let data = try JSONEncoder().encode(items)
            try data.write(to: path)
        }
    }
    
    func readAllItems<T: Codable>(at path: URL) throws -> [T] {
        do {
            guard let data = fileManager.contents(atPath: path.path()) else{
                return []
            }
            return try JSONDecoder().decode([T].self, from: data)
        }
    }
    
    func readItem<T: Codable & Identifiable>(at path: URL, with identifier: any Hashable) throws -> T? {
        do {
            guard let data = fileManager.contents(atPath: path.path()) else{
                return nil
            }
            let elements: [T] = try JSONDecoder().decode([T].self, from: data)
            let element = elements.filter { element in element.id == identifier as? T.ID }.first
            return element
        }
    }
    
    func removeItem<T: Codable & Identifiable>(at path: URL, with identifier: any Hashable, of type: T.Type) throws {
        var items: [T] = try readAllItems(at: path)
        items.removeAll(where: { $0.id == identifier as! T.ID } )

        try items.forEach { item in
            try writeItem(at: path, item)
        }
    }
}
