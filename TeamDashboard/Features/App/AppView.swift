//
//  AppView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 12.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        SwitchStore(store) { initialState in
            switch initialState {
            case .intro:
                if let store = store.scope(state: \.intro, action: \.intro) {
                    IntroView(store: store)
                }
            case .main:
                if let store = store.scope(state: \.main, action: \.main) {
                    MainView(store: store)
                }
            }
        }
        .animation(.default, value: store.state)
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State.intro(IntroFeature.State()),
            reducer: {
                AppFeature()
            }
        )
    )
}
