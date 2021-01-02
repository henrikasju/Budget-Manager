//
//  Color+CoreDataProperties.swift
//  Appsai
//
//  Created by Henrikas J on 17/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


extension Color {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Color> {
        return NSFetchRequest<Color>(entityName: "Color")
    }

    @NSManaged public var alpha: Float
    @NSManaged public var blue: Float
    @NSManaged public var green: Float
    @NSManaged public var red: Float
    @NSManaged public var category: NSSet?
    @NSManaged public var colors: Colors?

}

// MARK: Generated accessors for category
extension Color {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: TransactonCategory)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: TransactonCategory)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}
