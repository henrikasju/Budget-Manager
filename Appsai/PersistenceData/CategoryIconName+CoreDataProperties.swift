//
//  CategoryIconName+CoreDataProperties.swift
//  Appsai
//
//  Created by Henrikas J on 17/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryIconName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryIconName> {
        return NSFetchRequest<CategoryIconName>(entityName: "CategoryIconName")
    }

    @NSManaged public var name: String
    @NSManaged public var category: NSSet?
    @NSManaged public var iconNames: CategoryIconNames?

}

// MARK: Generated accessors for category
extension CategoryIconName {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: TransactonCategory)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: TransactonCategory)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}
