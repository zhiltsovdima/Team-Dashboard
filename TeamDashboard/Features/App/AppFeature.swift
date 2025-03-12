//
//  AppFeature.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 11.03.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
        
    @ObservableState
    enum State: Equatable {
        case intro(IntroFeature.State)
        case main(MainFeature.State)
    }
    
    enum Action {
        case intro(IntroFeature.Action)
        case main(MainFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .intro(.showMain):
                state = .main(MainFeature.State())
                return .none
            case .intro, .main:
                return .none
            }
        }
        .ifCaseLet(\.intro, action: \.intro) {
            IntroFeature()
        }
        .ifCaseLet(\.main, action: \.main) {
            MainFeature()
        }
    }
}
