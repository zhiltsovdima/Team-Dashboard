//
//  TeamDashboardApp.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TeamDashboardApp: App {
    
    let store = Store(initialState: AppFeature.State.intro(IntroFeature.State())) {
        AppFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
