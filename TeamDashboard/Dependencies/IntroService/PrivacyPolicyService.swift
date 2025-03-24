//
//  PrivacyPolicyService.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 11.03.2025.
//

import ComposableArchitecture
import Foundation

struct PrivacyPolicyService {
    var fetchPolicy: () async throws -> String
}

extension PrivacyPolicyService: DependencyKey {
    static let liveValue = PrivacyPolicyService(
        fetchPolicy: {
            try await Task.sleep(for: .seconds(2))
            return "Privacy Policy"
        }
    )
    
    static let testValue = PrivacyPolicyService(
        fetchPolicy: { "Test Policy" }
    )
}
