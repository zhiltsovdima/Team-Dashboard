//
//  TeamRepository.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import CoreData

protocol TaskRepository {
    func saveTasks(_ tasks: [WorkTask]) async throws
    func fetchTasks() async throws -> [WorkTask]
    func removeTask(id: UUID) async throws
}

protocol NotificationRepository {
    func saveNotifications(_ notifications: [WorkNotification]) async throws
    func fetchNotifications() async throws -> [WorkNotification]
    func updateNotification(id: UUID, isRead: Bool) async throws
    func removeNotification(id: UUID) async throws
}

final class CoreDataTeamRepository {
    private let storage: StorageStackInterface
    
    init(storage: StorageStackInterface) {
        self.storage = storage
    }
}

// MARK: - Private Helpers

private extension CoreDataTeamRepository {
    func performSave(context: NSManagedObjectContext, operation: @escaping (NSManagedObjectContext) throws -> Int) async throws {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let _ = try operation(context)
                    try self.storage.save(context: context)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: PersistenceError.saveFailed)
                }
            }
        }
    }
    
    func performFetch<T>(context: NSManagedObjectContext, operation: @escaping (NSManagedObjectContext) throws -> [T]) async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let results = try operation(context)
                    continuation.resume(returning: results)
                } catch {
                    continuation.resume(throwing: PersistenceError.fetchFailed)
                }
            }
        }
    }
    
    func performUpdate(context: NSManagedObjectContext, operation: @escaping (NSManagedObjectContext) throws -> Void) async throws {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    try operation(context)
                    try self.storage.save(context: context)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func performRemove(context: NSManagedObjectContext, entityName: String, id: UUID) async throws {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                do {
                    let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
                    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    let entities = try context.fetch(request)
                    if let entity = entities.first {
                        context.delete(entity)
                        try self.storage.save(context: context)
                    }
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: PersistenceError.deleteFailed)
                }
            }
        }
    }
}

// MARK: - Tasks

extension CoreDataTeamRepository: TaskRepository {
    func saveTasks(_ tasks: [WorkTask]) async throws {
        try await performSave(context: storage.backgroundContext()) { context in
            for task in tasks {
                let entity = TaskEntity(context: context)
                entity.id = task.id
                entity.title = task.title
                entity.deadline = task.deadline
            }
            return tasks.count
        }
    }
    
    func fetchTasks() async throws -> [WorkTask] {
        try await performFetch(context: storage.uiContext) { context in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let entities = try context.fetch(request)
            return entities.map { WorkTask(from: $0) }
        }
    }
    
    func removeTask(id: UUID) async throws {
        try await performRemove(context: storage.backgroundContext(), entityName: "TaskEntity", id: id)
    }
}
