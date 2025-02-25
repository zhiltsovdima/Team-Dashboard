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
}
