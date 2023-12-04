//
//  URL+TaskEndpoint.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation

extension URL {
    static let tasksPath: URL = {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.tasks1")!
        return container.appendingPathComponent("task")
    }()
}
