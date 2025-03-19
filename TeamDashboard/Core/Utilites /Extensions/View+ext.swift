//
//  View+ext.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 19.03.2025.
//

import ComposableArchitecture
import SwiftUI

extension View {
    func withPerceptionTracking() -> some View {
        WithPerceptionTracking { self }
    }
}
