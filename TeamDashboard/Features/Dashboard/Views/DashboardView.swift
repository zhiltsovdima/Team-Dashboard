//
//  DashboardView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
    @Perception.Bindable var store: StoreOf<DashboardFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                switch store.status {
                case .loading:
                    loadingView
                case .loaded:
                    loadedView
                case .error(let message):
                    errorView(message)
                }
            } destination: { store in
                TaskDetailView(store: store)
            }
            .refreshable {
                store.send(.fetchData)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
    var loadingView: some View {
        ProgressView()
    }
    
    func errorView(_ message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(.red)
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.black)
            Button {
                store.send(.fetchData)
            } label: {
                Text("Обновить")
                    .font(.system(size: 14,weight: .bold))
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
    }
    
    var loadedView: some View {
        ScrollView {
            VStack(spacing: 16) {
                MetricView(title: "Обработано заказов", value: store.metric)
                ForEach(store.tasks) { task in
                    WithPerceptionTracking {
                        Button {
                            store.send(.taskRowPressed(task.id))
                        } label: {
                            TaskRowView(
                                store: store,
                                task: task
                            )
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    DashboardView(
        store: Store(
            initialState: DashboardFeature.State(
                tasks: [
                    WorkTask(id: UUID(), title: "Title", deadline: Date())
                ],
                status: .loading
            ),
            reducer: {
                DashboardFeature()
            }
        )
    )
}
