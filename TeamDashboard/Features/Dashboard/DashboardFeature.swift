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
        case loading
        case loaded
        case error(message: String)
    }
    
    @ObservableState
    struct State: Equatable {
        var tasks: IdentifiedArrayOf<WorkTask> = []
        var metric: Int = 0
        var status: DashboardStatus
        
        var path = StackState<TaskDetailFeature.State>()
        
        var isInitialized: Bool = false
    }
    
    enum Action {
        case fetchData
        case dataResponse(Result<DashboardData, NetworkError>)
        
        case taskRowPressed(UUID)
        case completeTaskButtonPressed(for: UUID)
        
        case onAppear
        case path(StackActionOf<TaskDetailFeature>)
    }
    
    // Если нужна логика перехода на различные экрана(экран А, экран Б и тд)
//    @Reducer
//    enum Path {
//        case taskDetail(TaskDetailFeature)
//    }
    
    @Dependency(\.remoteTeamService) var remoteTeamService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            // TODO: Проверить в документации возможность разбивать Action на подгрупы
            // В случае большого кол-ва экшенов, декомпозиция будет кстати,
            // но кратно повышается риск забыть обработать правильный кейс из-за default
            switch action {
            case .fetchData, .dataResponse:
                return handleNetworkActions(&state, action)
                
            case .taskRowPressed, .completeTaskButtonPressed:
                return handleButtonActions(&state, action)
                
            case .path, .onAppear:
                return handleNavigationActions(&state, action)
            }
        }
        .forEach(\.path, action: \.path) {
            TaskDetailFeature()
        }
    }
    
    // MARK: - Actions handlers
    
    private func handleNetworkActions(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .fetchData:
            return .run { send in
                do {
                    let data = try await remoteTeamService.fetchDashboardData()
                    await send(.dataResponse(.success(data)))
                } catch let netError as NetworkError {
                    await send(.dataResponse(.failure(netError)))
                }
            }
            
        case .dataResponse(.success(let data)):
            state.tasks = IdentifiedArray(uniqueElements: data.tasks)
            state.metric = data.dailyMetric
            state.status = .loaded
            return .none
            
        case .dataResponse(.failure(let error)):
            state.status = .error(message: error.localizedDescription)
            return .none
            
        default:
            return .none
        }
    }
    
    private func handleButtonActions(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .taskRowPressed(let id):
            guard let task = state.tasks[id: id] else { return .none }
            state.path.append(TaskDetailFeature.State(task: task))
            return .none
            
        case .completeTaskButtonPressed(for: let taskId):
            if let task = state.tasks[id: taskId] {
                let newIsCompleted = !task.isCompleted
                state.tasks[id: taskId]?.isCompleted = newIsCompleted
                state.metric += newIsCompleted ? 1 : -1
            }
            return .none
        default:
            return .none
        }
    }
    
    private func handleNavigationActions(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            guard !state.isInitialized else { return .none }
            state.isInitialized = true
            return .send(.fetchData)
            
        case .path(.element(id: let id, action: .delegate(.completeButtonPressed))):
            guard let detailState = state.path[id: id] else { return .none }
            return .send(.completeTaskButtonPressed(for: detailState.task.id))
            
        case .path:
            return .none
            
        default:
            return .none
        }
    }
}
