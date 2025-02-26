//
//  PersistenceLogger.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//

import Foundation
import OSLog
import CoreData

struct PersistenceLogger {
    
    enum LoggingMode {
        /// Только критические ошибки
        case minimal
        /// Логи операций (create, fetch, update) и ошибок
        case standard
        /// Полные детали: запросы, данные сущностей
        case verbose
    }
    
    private static let logger = Logger(subsystem: "com.zhiltsovdima.TeamDashboard", category: "persistence")
    private static let mode: LoggingMode = .verbose
    
    static func logCreate(entityName: String, id: UUID, attributes: [String: Any]?) {
        guard mode != .minimal else { return }
        
        logger.info("[PersistenceLogger] Create entity: \(entityName, privacy: .public), ID: \(id.uuidString, privacy: .public)")
        if mode == .verbose, let attributes {
            let attributesString = attributes.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            logger.debug("Attributes: \(attributesString, privacy: .private)")
        }
    }
    
    static func logFetch(entityName: String, predicate: NSPredicate?, fetchCount: Int) {
        guard mode != .minimal else { return }
        
        logger.info("[PersistenceLogger] Fetch entity: \(entityName, privacy: .public)")
        logger.info("Fetched \(fetchCount, privacy: .public) items")
        
        if mode == .verbose, let predicate {
            logger.debug("Predicate: \(predicate.predicateFormat, privacy: .private)")
        }
    }
    
    static func logUpdate(entityName: String, id: UUID, changes: [String: Any]?) {
        guard mode != .minimal else { return }
        
        logger.info("[PersistenceLogger] Update entity: \(entityName, privacy: .public), ID: \(id.uuidString, privacy: .public)")
        if mode == .verbose, let changes {
            let changesString = changes.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            logger.debug("Changes: \(changesString, privacy: .private)")
        }
    }
    
    static func logDelete(entityName: String, id: UUID) {
        guard mode != .minimal else { return }
        
        logger.info("[PersistenceLogger] Delete entity: \(entityName, privacy: .public), ID: \(id.uuidString, privacy: .public)")
    }
    
    static func logSave(entityName: String, count: Int) {
        guard mode != .minimal else { return }
        
        logger.info("[PersistenceLogger] Save entity: \(entityName, privacy: .public), Count: \(count, privacy: .public)")
    }
    
    static func logError(_ error: Error) {
        logger.error("🔴 [PersistenceLogger] ERROR: \(error.localizedDescription, privacy: .public)")
    }
}
