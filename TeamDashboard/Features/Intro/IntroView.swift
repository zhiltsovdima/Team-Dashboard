//
//  IntroView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 12.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct IntroView: View {
    let store: StoreOf<IntroFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                if store.isLoading {
                    ProgressView()
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    IntroView(store: Store(initialState: IntroFeature.State(), reducer: {
        IntroFeature()
    }))
}
