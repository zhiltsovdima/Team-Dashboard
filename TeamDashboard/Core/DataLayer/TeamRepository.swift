//
//  TeamRepository.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import CoreData

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
                    let count = try operation(context)
                    try self.storage.save(context: context)
                    PersistenceLogger.logSave(entityName: context.registeredObjects.first?.entity.name ?? "Unknown", count: count)
                    continuation.resume()
                } catch {
                    PersistenceLogger.logError(error)
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
                    PersistenceLogger.logFetch(entityName: context.registeredObjects.first?.entity.name ?? "Unknown", predicate: nil, fetchCount: results.count)
                    continuation.resume(returning: results)
                } catch {
                    PersistenceLogger.logError(error)
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
                    PersistenceLogger.logError(error)
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
                        PersistenceLogger.logDelete(entityName: entityName, id: id)
                    }
                    continuation.resume()
                } catch {
                    PersistenceLogger.logError(error)
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
                PersistenceLogger.logCreate(entityName: "Task", id: task.id, attributes: [
                    "title": task.title,
                    "deadline": task.deadline.description
                ])
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

// MARK: - Notifications

extension CoreDataTeamRepository: NotificationRepository {
    func saveNotifications(_ notifications: [WorkNotification]) async throws {
        try await performSave(context: storage.backgroundContext()) { context in
            for notification in notifications {
                let entity = NotificationEntity(context: context)
                entity.id = notification.id
                entity.message = notification.message
                entity.isRead = notification.isRead
                PersistenceLogger.logCreate(entityName: "Notification", id: notification.id, attributes: [
                    "message": notification.message,
                    "isRead": notification.isRead
                ])
            }
            return notifications.count
        }
    }
    
    func fetchNotifications() async throws -> [WorkNotification] {
        try await performFetch(context: storage.uiContext) { context in
            let request: NSFetchRequest<NotificationEntity> = NotificationEntity.fetchRequest()
            let entities = try context.fetch(request)
            return entities.map { WorkNotification(from: $0) }
        }
    }
    
    func updateNotification(id: UUID, isRead: Bool) async throws {
        try await performUpdate(context: storage.uiContext) { context in
            let request: NSFetchRequest<NotificationEntity> = NotificationEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let entities = try context.fetch(request)
            guard let entity = entities.first else {
                throw PersistenceError.entityNotFound
            }
            entity.isRead = isRead
            PersistenceLogger.logUpdate(entityName: "Notification", id: id, changes: ["isRead": isRead])
        }
    }
    
    func removeNotification(id: UUID) async throws {
        try await performRemove(context: storage.backgroundContext(), entityName: "NotificationEntity", id: id)
    }
}
