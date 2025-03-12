//
//  TermsOfUseService.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 11.03.2025.
//

import ComposableArchitecture
import Foundation

struct TermsOfUseService {
    var fetchTerms: () async throws -> String
}

extension TermsOfUseService: DependencyKey {
    static let liveValue = TermsOfUseService(
        fetchTerms: {
            try await Task.sleep(for: .seconds(1))
            return "Terms of Use"
        }
    )
    
    static let testValue = TermsOfUseService(
        fetchTerms: { "Test Terms" }
    )
}
