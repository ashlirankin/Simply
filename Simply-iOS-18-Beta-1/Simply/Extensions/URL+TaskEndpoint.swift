//
//  URL+TaskEndpoint.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation

extension URL {
    
    static let appGroupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.app.intent.demo")!
    
    static let tasksEndpoint: URL = {
        return .appGroupContainerURL.appendingPathComponent("tasks.json")
    }()
}
