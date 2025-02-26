//
//  StorageStack.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import CoreData

/// Многоуровневая реализация стека CoreData для управления контекстами
///
/// - Суть:
///   - Изменения от дочерних контекстов стекаются в родительский контекст `writeContext`а затем в базу
///   - `writeContext` (private queue): Родительский контекст, единая точка записи в базу
///   - `uiContext` (main queue): Дочерний, для чтения и UI-операций
///   - `backgroundContext` (private queue): Дочерний, для фоновой записи
///
/// - Особенности:
///   - Повышает производительность при многопоточности.
///   - Эффективно использовать в больших проектах с активным UI и фоновыми операциями

// MARK: Interface

protocol StorageStackInterface {
    var uiContext: NSManagedObjectContext { get }
    
    func backgroundContext() -> NSManagedObjectContext
    func save(context: NSManagedObjectContext) throws
}

// MARK: - StorageStack

final class StorageStack: StorageStackInterface {
    private let container: NSPersistentContainer
    private let writeContext: NSManagedObjectContext
    
    var uiContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(config: StorageConfig) {
        container = NSPersistentContainer(name: config.modelName)
        
        if config.inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        writeContext.persistentStoreCoordinator = container.persistentStoreCoordinator
        writeContext.mergePolicy = config.mergePolicy
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = config.mergePolicy
        container.viewContext.parent = writeContext
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.parent = writeContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = writeContext.mergePolicy
        return context
    }
    
    func save(context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.performAndWait {
            try context.save()
        }
        try saveParentIfNeeded(context)
    }

    private func saveParentIfNeeded(_ context: NSManagedObjectContext) throws {
        if let parent = context.parent, parent.hasChanges {
            try parent.performAndWait {
                try parent.save()
            }
        }
    }
}
