//
//  Transaction+CoreDataProperties.swift
//  Appsai
//
//  Created by Henrikas J on 18/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var transactionCost: Double
    @NSManaged public var transactionPlace: String
    @NSManaged public var note: String
    @NSManaged public var date: Date
    @NSManaged public var category: TransactonCategory

}
