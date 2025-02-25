//
//  PersistenceError.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation

enum PersistenceError: Error {
    case storage(Error)
    case invalidEntity
    case fetchFailed
    case saveFailed
    case contextNotFound
    case decoding
    
    var message: String {
        switch self {
        case .storage(let failure):
            return failure.localizedDescription
        case .invalidEntity:
            return "Invalid entity"
        case .fetchFailed:
            return "Failed to fetch data"
        case .saveFailed:
            return "Failed to save data"
        case .contextNotFound:
            return "Context not found"
        case .decoding:
            return "Failed to decode entity"
        }
    }
}
