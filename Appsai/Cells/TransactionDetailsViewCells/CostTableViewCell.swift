//
//  CostTableViewCell.swift
//  Appsai
//
//  Created by Henrikas J on 17/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

protocol CostTableViewCellDelegate {
    func getTextViewBottomYCoordinate(view :UIView)
}

class CostTableViewCell: UITableViewCell {
    
    enum CostOperator: Int {
        case add = 1
        case subtract = 0
    }
    
    var costValueText: String = ""
    var costValue: Double = 0
    var isCostValueWholeNumber: Bool = true
    
    var currencySymbol: String = "$"
    var decimalSeperator: Character = NumberFormatter().decimalSeparator.first ?? "."
    var budgetDecimalDotUsed: Bool = false
    
    var costTableViewCellDelegate: CostTableViewCellDelegate!
    
    let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
    
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var operatorSegmentControl: UISegmentedControl!
    
    override func awakeFromNib() {
        toolbar.sizeToFit()
        
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dissmisKeyboard))
                ], animated: false)
        
        costTextField.inputAccessoryView = toolbar
    }
    
    @objc func dissmisKeyboard(){
        costTextField.resignFirstResponder()
    }
    
    func setData(costInputPlaceHolder: String, selectedOperator: CostOperator, currencySymbol: String) {
        costTextField.delegate = self
        self.selectionStyle = .none
        
        setCostValue()
        
        costTextField.makeTextWritingDirectionLeftToRight(self)
        costTextField.placeholder = costInputPlaceHolder
        operatorSegmentControl.selectedSegmentIndex = selectedOperator.rawValue
        operatorSegmentControl.addTarget(self, action: #selector(OperatorSlided), for: .valueChanged)
        
        self.currencySymbol = currencySymbol
    }
    
    private func setCostValue() {
        if let text = costTextField.text {
            if let cost = Int(text) {
                costValue = Double(cost)
                costValueText.append(contentsOf: String(costValue))
            }else if let number = getDoubleFromText(text: text){
                costValue = number.doubleValue
                costValueText.append(contentsOf: String(costValue))
                isCostValueWholeNumber = false
            }else {
                costValue = 0
                costValueText = ""
            }
        }
    }
    
    private func getDoubleFromText(text: String) -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        let number = formatter.number(from: text)
        if number != nil {
            return number!
        }
        
        return nil
    }
    
    @objc func OperatorSlided()
    {
        if let currentOperator = CostOperator(rawValue: operatorSegmentControl.selectedSegmentIndex) {
            if currentOperator == .add {
                operatorSegmentControl.selectedSegmentTintColor = .green
            }else if currentOperator == .subtract {
                operatorSegmentControl.selectedSegmentTintColor = .red
            }
        }
    }
    

}

extension CostTableViewCell: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == costTextField, let text = textField.text?.dropLast(){
            text != "0" ? (textField.text = String(text)) : (textField.text = "")
        }
//        if let keyboardDismissGesture = self.viewTap{
//            keyboardDismissGesture.isEnabled = true
//        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == costTextField {
            if let text = textField.text{
                
                
                
                // Delete Action when text exist
                if string.isEmpty && !text.isEmpty{
                    let deletionStartIndex = text.index(text.startIndex, offsetBy: range.location)
                    let deletionEndIndex = text.index(deletionStartIndex, offsetBy: range.length)
                    let deletingSubstring = text[deletionStartIndex..<deletionEndIndex]
                    if deletingSubstring.contains(decimalSeperator) {
                        self.budgetDecimalDotUsed = false
                    }
                    print("Deleted: \(deletingSubstring)")
                    return true
                }else{
                    // TEXT MIGHT NOT EXIST
                    // None delete Action
                    
                    // Validate input: Allow only floats and decimal seperator
                    if (string.count == 1 && string == String(decimalSeperator)) || Float(string) != nil {
                        
                        let replaceStartIndex = text.index(text.startIndex, offsetBy: range.location)
                        let replaceEndIndex = text.index(replaceStartIndex, offsetBy: range.length)
                        let replaceSubstring = text[replaceStartIndex..<replaceEndIndex]
                        
                        let proposingString: String = String(text[text.startIndex..<replaceStartIndex]) + string + String(text[replaceEndIndex..<text.endIndex])
                        print("proposingString: \(proposingString)")

                        
                        // Deny input with decimal seperator, if textField has decimal seperator OR text.contains . and replace string !contains . and string contaisns .
                        if (string == String(decimalSeperator) && (self.budgetDecimalDotUsed && !replaceSubstring.contains(decimalSeperator)) ) || ( self.budgetDecimalDotUsed && !replaceSubstring.contains(decimalSeperator) && string.contains(decimalSeperator) ) || proposingString.count > 9{
                            return false
                        }
                        
                        var precisionCount: Int? = nil
                        var precisionPointIndex: String.Index? = nil
                        
                        if let indexOfDecimalSeperator: String.Index = text.firstIndex(of: decimalSeperator){
                            precisionPointIndex = indexOfDecimalSeperator
                            let startIndex: String.Index = text.index(after: indexOfDecimalSeperator)
                            precisionCount = text[startIndex..<text.endIndex].count
                        }
                        
                        let inputIndex = text.index(text.startIndex, offsetBy: range.location)
                        var inputIsAfterDecimalSeperator: Bool = false
                        if let indexOfDecimalSeperator = precisionPointIndex{
                            inputIsAfterDecimalSeperator = inputIndex > indexOfDecimalSeperator
                        }
                        
                        
                        print("Input is valid")
                            // Paste / Single character input
                        if range.length == 0 && ( (inputIsAfterDecimalSeperator && precisionCount ?? 0 < 2) || !inputIsAfterDecimalSeperator ){
                            print("Paste / Single character input")
                            if string.contains(decimalSeperator) {
                                self.budgetDecimalDotUsed = true
                            }
                            
                            if budgetDecimalDotUsed {print("Decimal seperator used!")}
                            return true
                            
                        }else if range.length > 0{
                            // Replace
                            print("Replace")
                            
                            // if input replace contains decimal seperator, set flag to true
                            if string.contains(decimalSeperator){
                                budgetDecimalDotUsed = true
                            
                            // if replaced substring had decimal seperator, set flag to false
                            }else if replaceSubstring.contains(decimalSeperator) {
                                budgetDecimalDotUsed = false
                            }
                            
                            return true
                        }else{
                            return false
                        }
                    }else {
                        return false
                    }
                }

            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == costTextField {
            if let text = textField.text, !text.isEmpty {
                let string = text as NSString
                let cost: Double = string.doubleValue
                if cost > 0 {
                    textField.text = String(format: "%.2f", cost) + currencySymbol
                }else{
                    textField.text = "0" + currencySymbol
                }
            }
        }
//        if let keyboardDismissGesture = self.viewTap{
//            keyboardDismissGesture.isEnabled = false
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if let keyboardDismissGesture = self.viewTap{
//            keyboardDismissGesture.isEnabled = true
//        }
//        return true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if let keyboardDismissGesture = self.viewTap{
//            keyboardDismissGesture.isEnabled = false
//        }
//    }
}
