//
//  TransactonCategory+CoreDataProperties.swift
//  Appsai
//
//  Created by Henrikas J on 18/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


extension TransactonCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactonCategory> {
        return NSFetchRequest<TransactonCategory>(entityName: "TransactonCategory")
    }

    @NSManaged public var givenBudget: Double
    @NSManaged public var name: String
    @NSManaged public var note: String
    @NSManaged public var date: Date
    @NSManaged public var color: Color
    @NSManaged public var iconName: CategoryIconName
    @NSManaged public var transactions: NSOrderedSet?

}

// MARK: Generated accessors for transactions
extension TransactonCategory {

    @objc(insertObject:inTransactionsAtIndex:)
    @NSManaged public func insertIntoTransactions(_ value: Transaction, at idx: Int)

    @objc(removeObjectFromTransactionsAtIndex:)
    @NSManaged public func removeFromTransactions(at idx: Int)

    @objc(insertTransactions:atIndexes:)
    @NSManaged public func insertIntoTransactions(_ values: [Transaction], at indexes: NSIndexSet)

    @objc(removeTransactionsAtIndexes:)
    @NSManaged public func removeFromTransactions(at indexes: NSIndexSet)

    @objc(replaceObjectInTransactionsAtIndex:withObject:)
    @NSManaged public func replaceTransactions(at idx: Int, with value: Transaction)

    @objc(replaceTransactionsAtIndexes:withTransactions:)
    @NSManaged public func replaceTransactions(at indexes: NSIndexSet, with values: [Transaction])

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSOrderedSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSOrderedSet)

}
