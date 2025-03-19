//
//  DashboardView.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 18.03.2025.
//

import ComposableArchitecture
import SwiftUI

struct DashboardView: View {
    let store: StoreOf<DashboardFeature>
    
    var body: some View {
        Text("Dashboard")
    }
}

#Preview {
    DashboardView(
        store: Store(
            initialState: DashboardFeature.State(),
            reducer: {
                DashboardFeature()
            }
        )
    )
}
