//
//  TaskDetailView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 26.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct TaskDetailView: View {
    let store: StoreOf<TaskDetailFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text(store.task.title)
                    .font(.headline)
                Text(store.task.deadline, style: .date)
                    .font(.subheadline)
                Button {
                    store.send(.completeButtonPressed)
                } label: {
                    Image(systemName: store.task.isCompleted ? "checkmark.square.fill" : "square")
                        .font(.system(size: 40))
                        .foregroundColor(store.task.isCompleted ? .green : .gray)
                }
                .buttonStyle(.plain)
                .padding(.vertical)

            }
            .navigationTitle("Детали задачи")
        }
    }
}

#Preview {
    TaskDetailView(
        store: Store(
            initialState: TaskDetailFeature.State(
                task: WorkTask(
                    id: UUID(),
                    title: "Test Title",
                    deadline: Date()
                )
            ),
            reducer: {
                TaskDetailFeature()
            }
        )
    )
}
