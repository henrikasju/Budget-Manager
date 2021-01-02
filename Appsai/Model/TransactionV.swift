//
//  Transaction.swift
//  Appsai
//
//  Created by Henrikas J on 13/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import Foundation

class TransactionV {

    var transactionPlace: String
    var transactionCost: Float
    var category: BudgetCategory
    
    init( transactionPlace: String, transactionCost: Float, assignedCategory: BudgetCategory ) {
        self.transactionPlace = transactionPlace
        self.transactionCost = transactionCost
        self.category = assignedCategory
    }
}
