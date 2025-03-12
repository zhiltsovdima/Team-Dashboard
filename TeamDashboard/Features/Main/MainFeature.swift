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
    
    struct State: Equatable {
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
