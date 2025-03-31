//
//  StorageConfig.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import CoreData

struct StorageConfig {
    let modelName: String
    let inMemory: Bool
    let mergePolicy: NSMergePolicy
    
    static let defaultConfig = StorageConfig(
        modelName: "TeamDashboard",
        inMemory: false,
        mergePolicy: .mergeByPropertyObjectTrump
    )
    
    #if DEBUG
    static let testConfig = StorageConfig(
        modelName: "TeamDashboard",
        inMemory: true,
        mergePolicy: .mergeByPropertyObjectTrump
    )
    #endif
}
