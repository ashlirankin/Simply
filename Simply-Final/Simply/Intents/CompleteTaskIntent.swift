//
//  CompleteTaskIntent.swift
//  Simply
//
//  Created by Ashli Rankin on 12/5/23.
//

import Foundation
import AppIntents

struct CompleteTaskIntent: AppIntent {

    @Parameter(title: "Date")
    var date: Date
    
    @Parameter(title: "Task")
    private var task: TodoTask

    static var title: LocalizedStringResource = "Complete Task"
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
