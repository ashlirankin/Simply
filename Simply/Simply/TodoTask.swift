//
//  TodoTask.swift
//  Simply
//
//  Created by Ashli Rankin on 12/4/23.
//

import Foundation

struct TodoTask: Codable, Identifiable  {
    
    var id: UUID = UUID()
    
    let title: String
    
    var createDate: Date = Date()
    
    let executedDate: Date
    
    var isComplete: Bool = false
}
