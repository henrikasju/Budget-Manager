//
//  Colors+CoreDataProperties.swift
//  Appsai
//
//  Created by Henrikas J on 17/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


extension Colors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Colors> {
        return NSFetchRequest<Colors>(entityName: "Colors")
    }

    @NSManaged public var colors: NSOrderedSet?

}

// MARK: Generated accessors for colors
extension Colors {

    @objc(insertObject:inColorsAtIndex:)
    @NSManaged public func insertIntoColors(_ value: Color, at idx: Int)

    @objc(removeObjectFromColorsAtIndex:)
    @NSManaged public func removeFromColors(at idx: Int)

    @objc(insertColors:atIndexes:)
    @NSManaged public func insertIntoColors(_ values: [Color], at indexes: NSIndexSet)

    @objc(removeColorsAtIndexes:)
    @NSManaged public func removeFromColors(at indexes: NSIndexSet)

    @objc(replaceObjectInColorsAtIndex:withObject:)
    @NSManaged public func replaceColors(at idx: Int, with value: Color)

    @objc(replaceColorsAtIndexes:withColors:)
    @NSManaged public func replaceColors(at indexes: NSIndexSet, with values: [Color])

    @objc(addColorsObject:)
    @NSManaged public func addToColors(_ value: Color)

    @objc(removeColorsObject:)
    @NSManaged public func removeFromColors(_ value: Color)

    @objc(addColors:)
    @NSManaged public func addToColors(_ values: NSOrderedSet)

    @objc(removeColors:)
    @NSManaged public func removeFromColors(_ values: NSOrderedSet)

}
