//
//  MainFeature.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 11.03.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MainFeature {
    
    @ObservableState
    struct State: Equatable {
        var tabBar: TabBarFeature.State
        var dashboard = DashboardFeature.State(status: .loading)
        var notifications = NotificationFeature.State()
        var profile = ProfileFeature.State()
    }
    
    enum Action {
        case tabBar(TabBarFeature.Action)
        case dashboard(DashboardFeature.Action)
        case notifications(NotificationFeature.Action)
        case profile(ProfileFeature.Action)
        
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.tabBar, action: \.tabBar) {
            TabBarFeature()
        }
        
        Scope(state: \.dashboard, action: \.dashboard) {
            DashboardFeature()
        }
        
        Scope(state: \.notifications, action: \.notifications) {
            NotificationFeature()
        }
        
        Scope(state: \.profile, action: \.profile) {
            ProfileFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .tabBar(.delegate(.didSelect(let tabItem))):
                state.tabBar.selectedTab = tabItem
                return .none
            case .tabBar:
                return .none
            case .dashboard, .notifications, .profile:
                return .none
            }
        }
    }
}
