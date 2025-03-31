//
//  TabBarFeatureTests.swift
//  TeamDashboardTests
//
//  Created by Dima Zhiltsov on 31.03.2025.
//

import ComposableArchitecture
import Testing

@testable import TeamDashboard

@MainActor
struct TabBarFeatureTests {
    
    @Test
    func tabSelection() async {
        let initialState = TabBarFeature.State(
            tabs: TabBarItem.allCases,
            selectedTab: .dashboard
        )
        
        let store = TestStore(initialState: initialState) {
            TabBarFeature()
        }
        
        await store.send(.didSelect(tab: .profile))
        
        await store.receive(\.delegate, TabBarFeature.Action.Delegate.didSelect(.profile))
    }
}
