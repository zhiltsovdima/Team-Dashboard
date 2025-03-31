//
//  TaskDetailFeature.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 26.03.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TaskDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        var task: WorkTask
    }
    
    enum Action {
        case delegate(Delegate)
        case completeButtonPressed
    }
    
    enum Delegate {
        case completeButtonPressed
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .completeButtonPressed:
                state.task.isCompleted.toggle()
                return .send(.delegate(.completeButtonPressed))
            case .delegate:
                return .none
            }
        }
    }
}
