//
//  InputTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 17/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

protocol InputTableViewCellDelegate {
    func getTextViewBottomYCoordinate(view :UIView)
}

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var inputTextField: UITextField!
    
    var inputTableViewCellDelegate: InputTableViewCellDelegate!
    
    func setCell(inputPlaceholder: String)
    {
        inputTextField.placeholder = inputPlaceholder
        inputTextField.delegate = self
        self.selectionStyle = .none
        inputTextField.returnKeyType = .done
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneWithKeyboard))
                ], animated: false)
        toolbar.sizeToFit()
        
        inputTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneWithKeyboard() {
        inputTextField.resignFirstResponder()
    }

}

extension InputTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inputTableViewCellDelegate.getTextViewBottomYCoordinate(view: textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.capitalized
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
