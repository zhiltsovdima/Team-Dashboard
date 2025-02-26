//
//  WorkNotification.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation

struct WorkNotification: Identifiable, Equatable {
    let id: UUID
    var message: String
    var isRead: Bool
    
    init(id: UUID, message: String, isRead: Bool) {
        self.id = id
        self.message = message
        self.isRead = isRead
    }
    
    init(from entity: NotificationEntity) {
        self.id = entity.id
        self.message = entity.message
        self.isRead = entity.isRead
    }
}
