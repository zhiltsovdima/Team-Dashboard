//
//  DashboardView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
    let store: StoreOf<DashboardFeature>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                switch store.status {
                case .none:
                    EmptyView()
                case .loading:
                    loadingView
                case .loaded(let tasks, let metric):
                    VStack(spacing: 16) {
                        Text("Обработано заказов: \(metric)")
                            .font(.system(size: 18, weight: .bold))
                        
                        ForEach(tasks) { task in
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .font(.system(size: 14))
                                Text(task.deadline, style: .date)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                case .error(let message):
                    errorView(message)
                }
            }
            .refreshable {
                store.send(.fetchData)
            }
        }
        .onAppear {
            store.send(.fetchData)
        }
    }
}

#Preview {
    DashboardView(
        store: Store(
            initialState: DashboardFeature.State(status: .none),
            reducer: {
                DashboardFeature()
            }
        )
    )
}

extension DashboardView {
    
    var loadingView: some View {
        ProgressView()
    }
    
    func errorView(_ message: String) -> some View {
        Text("Ошибка: \(message)")
            .font(.subheadline)
            .foregroundColor(.red)
    }
    
}
