//
//  DashboardFeature.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 17.03.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DashboardFeature {
    
    enum DashboardStatus: Equatable {
        case none
        case loading
        case loaded(tasks: [WorkTask], metric: Int)
        case error(message: String)
    }
    
    @ObservableState
    struct State: Equatable {
        var status: DashboardStatus
    }
    
    enum Action {
        case fetchData
        case dataResponse(Result<DashboardData, NetworkError>)
    }
    
    @Dependency(\.remoteTeamService) var remoteTeamService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchData:
                state.status = .loading
                return .run { send in
                    do {
                        let data = try await remoteTeamService.fetchDashboardData()
                        await send(.dataResponse(.success(data)))
                    } catch let netError as NetworkError {
                        await send(.dataResponse(.failure(netError)))
                    }
                }
            case .dataResponse(.success(let data)):
                state.status = .loaded(tasks: data.tasks, metric: data.dailyMetric)
                return .none
                
            case .dataResponse(.failure(let error)):
                state.status = .error(message: error.localizedDescription)
                return .none
            }
        }
    }
}
