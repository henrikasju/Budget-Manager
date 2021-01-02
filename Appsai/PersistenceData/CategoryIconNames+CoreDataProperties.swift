//
//  CategoryIconNames+CoreDataProperties.swift
//  Appsai
//
//  Created by Henrikas J on 17/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


extension CategoryIconNames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryIconNames> {
        return NSFetchRequest<CategoryIconNames>(entityName: "CategoryIconNames")
    }

    @NSManaged public var iconNames: NSOrderedSet?

}

// MARK: Generated accessors for iconNames
extension CategoryIconNames {

    @objc(insertObject:inIconNamesAtIndex:)
    @NSManaged public func insertIntoIconNames(_ value: CategoryIconName, at idx: Int)

    @objc(removeObjectFromIconNamesAtIndex:)
    @NSManaged public func removeFromIconNames(at idx: Int)

    @objc(insertIconNames:atIndexes:)
    @NSManaged public func insertIntoIconNames(_ values: [CategoryIconName], at indexes: NSIndexSet)

    @objc(removeIconNamesAtIndexes:)
    @NSManaged public func removeFromIconNames(at indexes: NSIndexSet)

    @objc(replaceObjectInIconNamesAtIndex:withObject:)
    @NSManaged public func replaceIconNames(at idx: Int, with value: CategoryIconName)

    @objc(replaceIconNamesAtIndexes:withIconNames:)
    @NSManaged public func replaceIconNames(at indexes: NSIndexSet, with values: [CategoryIconName])

    @objc(addIconNamesObject:)
    @NSManaged public func addToIconNames(_ value: CategoryIconName)

    @objc(removeIconNamesObject:)
    @NSManaged public func removeFromIconNames(_ value: CategoryIconName)

    @objc(addIconNames:)
    @NSManaged public func addToIconNames(_ values: NSOrderedSet)

    @objc(removeIconNames:)
    @NSManaged public func removeFromIconNames(_ values: NSOrderedSet)

}
