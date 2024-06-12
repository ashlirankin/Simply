//
//  TodoTask.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation
import AppIntents

struct TodoTask: Codable, Identifiable  {
    
    var id: UUID = UUID()
    
    let title: String
    
    var createDate: Date = Date()
    
    var executedDate: Date? = nil
    
    var isComplete: Bool = false
}
