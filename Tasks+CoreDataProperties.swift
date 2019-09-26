//
//  Tasks+CoreDataProperties.swift
//  
//
//  Created by IOS DEV on 25/09/2019.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var id: Int64
    @NSManaged public var taskName: String?
    @NSManaged public var checked: Bool

}
