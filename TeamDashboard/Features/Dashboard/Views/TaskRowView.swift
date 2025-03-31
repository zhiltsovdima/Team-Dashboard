//
//  TaskRowView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 26.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct TaskRowView: View {
    let store: StoreOf<DashboardFeature>
    let task: WorkTask
    
    var body: some View {
        WithPerceptionTracking {
            HStack(alignment: .center, spacing: 12) {
                Button {
                    store.send(.completeTaskButtonPressed(for: task.id))
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 14))
                        .foregroundColor(task.isCompleted ? .gray : .black)
                        .strikethrough(task.isCompleted)
                    Text(task.deadline, style: .time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    TaskRowView(
        store: Store(
            initialState: DashboardFeature.State(status: .loading),
            reducer: {
                DashboardFeature()
            }),
        task: .init(
            id: UUID(),
            title: "Test title",
            deadline: Date()
        )
    )
}
