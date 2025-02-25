//
//  TeamService.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation

protocol TeamService {
    func fetchDashboardData() async throws -> DashboardData
    func fetchNotifications() async throws -> [WorkNotification]
    func fetchEmployeeProfile() async throws -> Employee
}

final class TeamServiceMock: TeamService {
    func fetchDashboardData() async throws -> DashboardData {
        try await Task.sleep(for: .seconds(1))
        
        let tasks = [
            WorkTask(id: UUID(), title: "Обработать заказ #4815162342", deadline: Date()),
            WorkTask(id: UUID(), title: "Проверить склад", deadline: Date())
        ]
        return DashboardData(tasks: tasks, dailyMetric: 42)
    }
    
    func fetchNotifications() async throws -> [WorkNotification] {
        try await Task.sleep(for: .seconds(0.5))

        return [
            WorkNotification(id: UUID(), message: "Новая задача добавлена", isRead: false),
            WorkNotification(id: UUID(), message: "Срок задачи истекает", isRead: false)
        ]
    }
    
    func fetchEmployeeProfile() async throws -> Employee {
        try await Task.sleep(for: .seconds(0.8))

        return Employee(
            name: PersonName.mockName,
            role: .developer,
            weeklyStats: 256
        )
    }
}
