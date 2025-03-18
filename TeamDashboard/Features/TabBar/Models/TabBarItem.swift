//
//  TabBarItem.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 17.03.2025.
//

import Foundation

enum TabBarItem: String, Identifiable, Equatable, CaseIterable {
    case dashboard, notifications, profile
    
    var id: String { rawValue }
    
    var title: String {
        return rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .dashboard:
            return "house"
        case .notifications:
            return "bell"
        case .profile:
            return "person"
        }
    }
}
