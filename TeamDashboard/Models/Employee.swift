//
//  Employee.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation

struct Employee: Equatable {
    let name: PersonName
    let role: EmployeeRole
    let weeklyStats: Int
}

struct PersonName: Equatable {
    let value: String
    
    private init?(value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty,
              !trimmed.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        self.value = trimmed
    }
    
    static func create(_ value: String) -> PersonName? {
        return PersonName(value: value)
    }
}

enum EmployeeRole: String, CaseIterable {
    case developer
    case designer
    case manager
}
