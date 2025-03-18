//
//  TabBarFeature.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 17.03.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TabBarFeature {
    
    @ObservableState
    struct State: Equatable {
        var tabs: [TabBarItem]
        var selectedTab: TabBarItem
    }
    
    enum Action: Equatable {
        case didSelect(tab: TabBarItem)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case didSelect(TabBarItem)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didSelect(let tab):
                return .send(.delegate(.didSelect(tab)))
            case .delegate:
                return .none
            }
        }
    }
}
