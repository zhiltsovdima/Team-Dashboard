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
    
    init(id: UUID, title: String, deadline: Date) {
        self.id = id
        self.title = title
        self.deadline = deadline
    }
    
    init(from entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title
        self.deadline = entity.deadline
    }
}
