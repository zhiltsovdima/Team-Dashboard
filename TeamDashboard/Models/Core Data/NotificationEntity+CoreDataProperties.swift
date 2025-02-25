//
//  NotificationEntity+CoreDataProperties.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//
//

import Foundation
import CoreData


extension NotificationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationEntity> {
        return NSFetchRequest<NotificationEntity>(entityName: "NotificationEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var message: String?
    @NSManaged public var isRead: Bool

}

extension NotificationEntity : Identifiable {

}
