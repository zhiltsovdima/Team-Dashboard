//
//  TeamRepository.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import CoreData

//protocol TeamRepository {
//    func saveTasks(_ tasks: [WorkTask]) async throws
//    func fetchTasks() async throws -> [WorkTask]
//    func saveNotifications(_ notifications: [WorkNotification]) async throws
//    func fetchNotifications() async throws -> [WorkNotification]
//}
//
//final class CoreDataTeamRepository: TeamRepository {
//    private let storage: StorageStackInterface
//    
//    init(storage: StorageStackInterface) {
//        self.storage = storage
//    }
//    
//    func saveTasks(_ tasks: [WorkTask]) async throws {
//        try await withCheckedThrowingContinuation { continuation in
//            let context = storage.backgroundContext()
//            context.perform {
//                for task in tasks {
//                    let entity = TaskEntity(context: context)
//                    entity.id = task.id
//                    entity.title = task.title
//                    entity.deadline = task.deadline
//                    PersistenceLogger.logCreate(entityName: "Task", attributes: [
//                        "id": task.id,
//                        "title": task.title,
//                        "deadline": task.deadline.description
//                    ])
//                }
//                do {
//                    try self.storage.save(context: context)
//                    PersistenceLogger.logSave(entityName: "Task", count: tasks.count)
//                    continuation.resume()
//                } catch {
//                    PersistenceLogger.logError(error)
//                    continuation.resume(throwing: PersistenceError.saveFailed)
//                }
//            }
//        }
//    }
//    
//    func fetchTasks() async throws -> [WorkTask] {
//        try await withCheckedThrowingContinuation { continuation in
//            let context = storage.uiContext
//            context.perform {
//                let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//                do {
//                    let entities = try context.fetch(request)
//                    let tasks = entities.map { WorkTask(from: $0) }
//                    PersistenceLogger.logFetch(entityName: "Task", predicate: nil, fetchCount: tasks.count)
//                    continuation.resume(returning: tasks)
//                } catch {
//                    PersistenceLogger.logError(error)
//                    continuation.resume(throwing: PersistenceError.fetchFailed)
//                }
//            }
//        }
//    }
//    
//    func saveNotifications(_ notifications: [WorkNotification]) async throws {
//        try await withCheckedThrowingContinuation { continuation in
//            let context = storage.backgroundContext()
//            context.perform {
//                for notification in notifications {
//                    let entity = NotificationEntity(context: context)
//                    entity.id = notification.id
//                    entity.message = notification.message
//                    entity.isRead = notification.isRead
//                    PersistenceLogger.logCreate(entityName: "Notification", attributes: [
//                        "id": notification.id,
//                        "message": notification.message,
//                        "isRead": notification.isRead
//                    ])
//                }
//                do {
//                    try self.storage.save(context: context)
//                    PersistenceLogger.logSave(entityName: "Notification", count: notifications.count)
//                    continuation.resume()
//                } catch {
//                    PersistenceLogger.logError(error)
//                    continuation.resume(throwing: PersistenceError.saveFailed)
//                }
//            }
//        }
//    }
//    
//    func fetchNotifications() async throws -> [WorkNotification] {
//        try await withCheckedThrowingContinuation { continuation in
//            let context = storage.uiContext
//            context.perform {
//                let request: NSFetchRequest<NotificationEntity> = NotificationEntity.fetchRequest()
//                do {
//                    let entities = try context.fetch(request)
//                    let notifications = entities.map { WorkNotification(from: $0) }
//                    PersistenceLogger.logFetch(entityName: "Notification", predicate: nil, fetchCount: notifications.count)
//                    continuation.resume(returning: notifications)
//                } catch {
//                    PersistenceLogger.logError(error)
//                    continuation.resume(throwing: PersistenceError.fetchFailed)
//                }
//            }
//        }
//    }
//}
