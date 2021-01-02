//
//  ListOptionTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 29/04/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class ListOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ListOption: UIPickerView!
    
    var data: [TransactonCategory] = []
    
    var selectedCategory: TransactonCategory?
        
    func setCell(categories: [TransactonCategory]){
        ListOption.dataSource = self
        ListOption.delegate = self
        
        data = categories
        if let firstCategory = data.first{
            selectedCategory = firstCategory
        }
        
        self.selectionStyle = .none
    }
}

extension ListOptionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("User Selected: " + data[row].name)
        selectedCategory = data[row]
    }
}
