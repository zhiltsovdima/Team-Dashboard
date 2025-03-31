//
//  TaskEntity+CoreDataProperties.swift
//  TeamDashboard
//
//  Created by Dima Zhiltsov on 25.02.2025.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var deadline: Date
    @NSManaged public var isCompleted: Bool

}

extension TaskEntity : Identifiable {

}
