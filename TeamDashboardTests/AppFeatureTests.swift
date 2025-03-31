//
//  AppFeatureTests.swift
//  TeamDashboardTests
//
//  Created by Dima Zhiltsov on 31.03.2025.
//

import ComposableArchitecture
import Testing

@testable import TeamDashboard

@MainActor
struct AppFeatureTests {
    
    @Test
    func introFeatureLoading() async {
        let testData = IntroData(termsOfUse: "Test Terms", privacyPolicy: "Test Policy")

        let store = TestStore(initialState: IntroFeature.State()) {
            IntroFeature()
        } withDependencies: {
            // можно использовать либо готовую заглушку либо подставлять сюда ожидаемую testData
            $0.introDataService = .testValue
        }

        await store.send(.onAppear) {
            $0.isLoading = true
        }

        await store.receive(\.dataLoaded, testData) {
            $0.isLoading = false
            $0.introData = testData
        }

        await store.receive(\.showMain)
    }
    
    @Test
    func introFeatureLoadingFailure() async {
        let store = TestStore(initialState: IntroFeature.State()) {
            IntroFeature()
        } withDependencies: {
            $0.introDataService.fetchData = { throw NetworkError.invalidURL }
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.dataLoadingFailed)
    }
    
}
