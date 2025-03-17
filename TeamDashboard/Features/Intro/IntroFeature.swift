//
//  IntroFeature.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 11.03.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct IntroFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var introData: IntroData?
    }
    
    enum Action {
        case onAppear
        case dataLoaded(IntroData)
        case dataLoadingFailed
        case showMain
    }
    
    @Dependency(\.introDataService) var introDataService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    do {
                        try await send(.dataLoaded(introDataService.fetchData()))
                    } catch {
                        await send(.dataLoadingFailed)
                    }
                }
            case .dataLoaded(let data):
                state.isLoading = false
                state.introData = data
                return .send(.showMain)
            case .dataLoadingFailed:
                return .none
            case .showMain:
                return .none
            }
        }
    }
}
