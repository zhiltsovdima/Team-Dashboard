//
//  MainView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 12.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        Color.blue
    }
}

#Preview {
    MainView(
        store: Store(
            initialState: MainFeature.State(),
            reducer: {
                MainFeature()
            }
        )
    )
}
