//
//  MainView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 12.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                Group {
                    switch store.tabBar.selectedTab {
                    case .dashboard:
                        DashboardView(
                            store: store.scope(
                                state: \.dashboard,
                                action: \.dashboard
                            )
                        )
                    case .notifications:
                        Color.green
                    case .profile:
                        Color.blue
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom) {
                    TabBarView(store: store.scope(state: \.tabBar, action: \.tabBar), style: .default)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    MainView(
        store: Store(
            initialState: MainFeature.State(
                tabBar: TabBarFeature.State(
                    tabs: TabBarItem.allCases,
                    selectedTab: .dashboard
                )
            ),
            reducer: {
                MainFeature()
            }
        )
    )
}
