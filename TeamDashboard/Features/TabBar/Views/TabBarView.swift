//
//  TabBarView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct TabBarView: View {
    let store: StoreOf<TabBarFeature>
    let style: TabBarStyle
    
    var body: some View {
        HStack {
            ForEach(store.tabs) { tabItem in
                TabBarItemView(
                    model: tabItem,
                    style: .default,
                    isSelected: store.selectedTab == tabItem
                ) {
                    store.send(.didSelect(tab: tabItem))
                }
                .frame(maxWidth: .infinity)
                .withPerceptionTracking()
            }
        }
        .padding(.horizontal, 16)
        .background(style.backgroundColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(style.borderColor,
                        lineWidth: style.borderWidth))
        .frame(height: 60)
        .withPerceptionTracking()
    }
}

#Preview {
    TabBarView(
        store: Store(
            initialState: TabBarFeature.State(
                tabs: TabBarItem.allCases,
                selectedTab: .dashboard
            ),
            reducer: {
                TabBarFeature()
            }
        ),
        style: .default
    )
}
