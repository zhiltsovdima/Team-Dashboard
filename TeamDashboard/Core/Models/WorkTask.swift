//
//  WorkTask.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation

struct WorkTask: Identifiable, Equatable {
    let id: UUID
    let title: String
    let deadline: Date
    var isCompleted: Bool
    
    init(id: UUID, title: String, deadline: Date, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.deadline = deadline
        self.isCompleted = isCompleted
    }
    
    init(from entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title
        self.deadline = entity.deadline
        self.isCompleted = entity.isCompleted
    }
}
