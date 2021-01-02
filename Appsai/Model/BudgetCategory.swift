//
//  Categories.swift
//  Appsai
//
//  Created by Henrikas J on 14/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import Foundation
import UIKit

class BudgetCategory {
    
    var name: String
    var color: UIColor
    var imageName: String
    var givenBudget: Float
    var transactions: [TransactionV]
    
    init(name: String, color: UIColor, imageName: String, givenBudget: Float, transactions: [TransactionV] = [] ) {
        self.name = name
        self.imageName = imageName
        self.color = color
        self.givenBudget = givenBudget
        self.transactions = transactions
    }
    
    func getTransactionsCount() -> Int {
        return self.transactions.count
    }
    
    func setTransactions(transactions: [TransactionV])
    {
        self.transactions = transactions
    }
    
}
