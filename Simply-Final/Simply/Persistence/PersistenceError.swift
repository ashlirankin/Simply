//
//  PersistenceError.swift
//  Simply
//
//  Created by Ashli Rankin on 12/5/23.
//

import Foundation

enum PersistenceError: LocalizedError {
    case unableToRead
    case unableToWrite
    case failedToRemove
    case decodingError
    case noDataAvailable
    case directoryCreationFailed
}
