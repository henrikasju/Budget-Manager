//
//  BudgetTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 13/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var TransactionPlaceLabel: UILabel!
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var TransactionCost: UILabel!
    
    var currencySymbol: String = "$"
    
    func setData(categoryImageName: String, categoryColor: UIColor, categoryLabel: String, transactionLabel: String, transactionCost: Double, currencySymbol: String) {
                        
        CategoryButton.backgroundColor = categoryColor
        CategoryButton.layer.cornerRadius = CGFloat(5)
        CategoryButton.tintColor = .white
        CategoryButton.setTitle(categoryLabel, for: .normal)

        TransactionPlaceLabel.text = transactionLabel
        
        let imageConfig = UIImage.SymbolConfiguration(weight: .light)
        CategoryImage.image = UIImage(systemName: categoryImageName, withConfiguration: imageConfig)
        CategoryImage.tintColor = categoryColor
                        
        
        if transactionCost >= 0 {
            TransactionCost.text = "+" + String(format: "%.2f", transactionCost)
            TransactionCost.textColor = .systemGreen
        }else {
            TransactionCost.text = String(format: "%.2f", transactionCost)
            TransactionCost.textColor = .systemRed
        }
        
        TransactionCost.text! += currencySymbol
    }
}


