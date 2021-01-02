//
//  BudgetTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 29/04/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var CategoryBudget: UILabel!
    @IBOutlet weak var BudgetVerdictLabel: UILabel!
    
    func setData(categoryImageName: String, categoryColor: UIColor, categoryLabel: String, givenBudget: Double, currencySymbol: String) {
                        
        CategoryButton.backgroundColor = categoryColor
        CategoryButton.layer.cornerRadius = CGFloat(5)
        CategoryButton.tintColor = .white
        CategoryButton.setTitle(categoryLabel, for: .normal)
        
        let imageConfig = UIImage.SymbolConfiguration(weight: .light)
        CategoryImage.image = UIImage(systemName: categoryImageName, withConfiguration: imageConfig)
        CategoryImage.tintColor = categoryColor
        
                        
        if givenBudget >= 0 {
            CategoryBudget.text = "+" + String(format: "%.2f", givenBudget)
            BudgetVerdictLabel.textColor = .systemGreen
        }else {
            CategoryBudget.text = String(format: "%.2f", givenBudget)
            BudgetVerdictLabel.textColor = .systemRed
            BudgetVerdictLabel.text = "Exceeded"
        }
        
        CategoryBudget.text! += currencySymbol
        
    }
}
