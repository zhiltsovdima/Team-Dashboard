//
//  IntroDataService.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 11.03.2025.
//

import ComposableArchitecture
import Foundation

/// Сервис для имитации загрузки условных стартовых данных на экране приветствия
/// Задачи:
///  - `Демонстрация переключения потока`: переключение флоу в архитектуре TCA (с intro на main)
///  - `Тестирование подхода от pointfree`:  использование структуры с замыканиями и зависимостями вместо классического протокольного подхода
///  - `Декомпозиции логики`: разделение ответственности, где каждая структура отвечает за свою часть логики

struct IntroDataService {
    var fetchData: () async throws -> IntroData
    
    init(
        termsService: TermsOfUseService,
        policyService: PrivacyPolicyService
    ) {
        self.fetchData = {
            async let terms = termsService.fetchTerms()
            async let policy = policyService.fetchPolicy()
            let (termsOfUse, privacyPolicy) = try await (terms, policy)
            return IntroData(
                termsOfUse: termsOfUse,
                privacyPolicy: privacyPolicy
            )
        }
    }
}

extension IntroDataService: DependencyKey {
    static let liveValue = IntroDataService(
        termsService: .liveValue,
        policyService: .liveValue
    )
    
    static let testValue = IntroDataService(
        termsService: .testValue,
        policyService: .testValue
    )
}

extension DependencyValues {
    var introDataService: IntroDataService {
        get { self[IntroDataService.self] }
        set { self[IntroDataService.self] = newValue }
    }
    
    var termsOfUseService: TermsOfUseService {
        get { self[TermsOfUseService.self] }
        set { self[TermsOfUseService.self] = newValue }
    }
    
    var privacyPolicyService: PrivacyPolicyService {
        get { self[PrivacyPolicyService.self] }
        set { self[PrivacyPolicyService.self] = newValue }
    }
}
