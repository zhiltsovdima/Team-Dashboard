//
//  DashboardFeatureTests.swift
//  TeamDashboardTests
//
//  Created by Dima Zhiltsov on 31.03.2025.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import TeamDashboard

@MainActor
struct DashboardFeatureTests {
    
    @Test
    func taskRowPressed() async {
        let task = WorkTask(id: UUID(), title: "Task 1", deadline: Date())
        let initialState = DashboardFeature.State(
            tasks: IdentifiedArray(uniqueElements: [task]),
            status: .loaded
        )
        
        let store = TestStore(initialState: initialState) {
            DashboardFeature()
        }
        
        await store.send(.taskRowPressed(task.id)) {
            $0.path = StackState([TaskDetailFeature.State(task: task)])
        }
    }
    
    @Test
    func completeTask() async {
        let task = WorkTask(id: UUID(), title: "Task 1", deadline: Date())
        let initialState = DashboardFeature.State(
            tasks: IdentifiedArray(uniqueElements: [task]),
            status: .loaded
        )
        
        let store = TestStore(initialState: initialState) {
            DashboardFeature()
        }
        
        await store.send(.completeTaskButtonPressed(for: task.id)) {
            $0.tasks[id: task.id]?.isCompleted = true
            $0.metric = 1
        }
    }
}
