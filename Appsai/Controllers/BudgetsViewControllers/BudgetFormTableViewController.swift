//
//  BudgetFormTableViewController.swift
//  Appsai
//
//  Created by Henrikas J on 06/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

// TODO: ADD NOTE
// TODO: editing cells used force unwraping

import UIKit

class BudgetFormTableViewController: UITableViewController {
    
    let persistenceManager: PersistenceManager!
    
    required init?(coder: NSCoder) {
        self.persistenceManager = PersistenceManager.shared
        super.init(coder: coder)
    }
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var budgetSizeTextField: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var logoCollectionView: UICollectionView!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    var editingCategory: TransactonCategory?
    
    let logoCellIdentifier = "Logo cell"
    let colorCellIdentifier = "Color cell"
    
    var selectedLogoIndex: IndexPath? = nil
    var selectedColorIndex: IndexPath? = nil
    
    var viewTap: UITapGestureRecognizer? = nil
    
    var colors: [Color] = []
    var iconsNames: [CategoryIconName] = []
    
    let currencySymbol: String = UserDefaults.standard.string(forKey: "CurrencyType") ?? "?"
    
    let decimalSeperator: Character = NumberFormatter().decimalSeparator.first ?? "."
    
    var budgetDecimalDotUsed: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print((editingCategory != nil) ? "Editing Mode" : "Add Mode")
        
        budgetSizeTextField.delegate = self
        categoryNameTextField.delegate = self
        notesTextView.delegate = self
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        logoCollectionView.dataSource = self
        logoCollectionView.delegate = self
        
//        budgetSizeTextField.text = "0" + currencySymbol
        
        if let colorArray = persistenceManager.fetch(Colors.self).first?.colors?.array as? [Color]{
            colors = colorArray
        }
        
        if let iconNameArray = persistenceManager.fetch(CategoryIconNames.self).first?.iconNames?.array as? [CategoryIconName]{
            iconsNames = iconNameArray
        }
        
        if editingCategory != nil {
            loadEditingData()
        }
        
        (self.view as! UITableView).keyboardDismissMode = .onDrag
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneWithKeyboard(sender:)))
                ], animated: false)
        toolbar.sizeToFit()
        
        budgetSizeTextField.inputAccessoryView = toolbar
        categoryNameTextField.inputAccessoryView = toolbar
        notesTextView.inputAccessoryView = toolbar
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        self.view.addGestureRecognizer(viewTap)
        viewTap.isEnabled = false
        self.viewTap = viewTap
        
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        
        budgetSizeTextField.placeholder = "0.00" + currencySymbol
        
//        decimalSeperator = formatter.decimalSeparator
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadEditingData() {
        guard let categoryName = editingCategory?.name else {
            return
        }

        guard let categoryGivenBudget = editingCategory?.givenBudget else {
            return
        }

        guard let categoryIconName = editingCategory?.iconName else {
            return
        }

        guard let categoryColor = editingCategory?.color else {
            return
        }
        
        guard let note = editingCategory?.note else {
            return
        }
        
        categoryNameTextField.text = categoryName
        budgetSizeTextField.text = String(format: "%.2f", categoryGivenBudget) + currencySymbol
        let colorIndex = colors.firstIndex(of: categoryColor)
        selectedColorIndex = IndexPath(row: colorIndex!, section: 0)
        let iconIndex = iconsNames.firstIndex(of: categoryIconName)
        selectedLogoIndex = IndexPath(row: iconIndex!, section: 0)
        notesTextView.text = note
    }
    
    @objc func doneWithKeyboard(sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func dissmisKeyboard(){
        self.view.endEditing(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return 60
        }else if indexPath.section == 3{
            return 85
        }else if indexPath.section == 4{
            return 160
        }else {
            return 55
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BudgetFormTableViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView{
            return colors.count
        }else if collectionView == logoCollectionView{
            return iconsNames.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == colorCollectionView{
            
            if self.selectedColorIndex == nil && indexPath.row == 0{
                self.selectedColorIndex = indexPath
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.colorCellIdentifier, for: indexPath) as! ColorCollectionViewCell
            
            let cellColor = colors[indexPath.row]
            let color = UIColor(red: CGFloat(cellColor.red), green: CGFloat(cellColor.green), blue: CGFloat(cellColor.blue), alpha: CGFloat(cellColor.alpha))
            
            if let selectedColor = self.selectedColorIndex{
                cell.startup(selected: (selectedColor == indexPath), color: color)
            }else{
                cell.startup(selected: false, color: color)
            }
            
            return cell
        }else {
            if self.selectedLogoIndex == nil && indexPath.row == 0{
                self.selectedLogoIndex = indexPath
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.logoCellIdentifier, for: indexPath) as! LogoCollectionViewCell
            let cellIconName = self.iconsNames[indexPath.row].name
            if let selectedLogo = self.selectedLogoIndex{
                cell.startup(selected: (selectedLogo == indexPath), iconName: cellIconName)
            }else{
                cell.startup(selected: false, iconName: cellIconName)
            }
            
            if let selectedColor = self.selectedColorIndex{
                let cellColor = colors[selectedColor.row]
                let color = UIColor(red: CGFloat(cellColor.red), green: CGFloat(cellColor.green), blue: CGFloat(cellColor.blue), alpha: CGFloat(cellColor.alpha))
                cell.logoImageView.tintColor = color
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == logoCollectionView{
            if let selectedIndex = self.selectedLogoIndex{
                if indexPath != selectedIndex{
                    self.selectedLogoIndex = indexPath
                    collectionView.reloadItems(at: [selectedIndex])
                    collectionView.reloadItems(at: [indexPath])
                    
                }
            }else{
                self.selectedLogoIndex = indexPath
                collectionView.reloadItems(at: [indexPath])
            }
        }else if collectionView == colorCollectionView{
            if let selectedIndex = self.selectedColorIndex{
                if indexPath != selectedIndex{
                    self.selectedColorIndex = indexPath
                    collectionView.reloadItems(at: [selectedIndex])
                    collectionView.reloadItems(at: [indexPath])
                    self.logoCollectionView.reloadData()
                }
            }else{
                self.selectedColorIndex = indexPath
                collectionView.reloadItems(at: [indexPath])
                self.logoCollectionView.reloadData()
            }
        }
    }
    
    
    
}

extension BudgetFormTableViewController: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == budgetSizeTextField, let text = textField.text?.dropLast(){
            text != "0" ? (textField.text = String(text)) : (textField.text = "")
        }
        if let keyboardDismissGesture = self.viewTap{
            keyboardDismissGesture.isEnabled = true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == budgetSizeTextField {
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

        
//            let stringContainDecimalSeperator: Bool = string.contains(decimalSeperator)
            

    
            // TODO: Please if deletion from selection
                
//                if self.budgetDecimalDotUsed && (text.firstIndex(of: self.decimalSeperator.first) ) {
//                    <#code#>
//                }
//                    return false
//                }
                // User wants to delete
                
                
//            textField.text?.contains()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == budgetSizeTextField {
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
        if let keyboardDismissGesture = self.viewTap{
            keyboardDismissGesture.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let keyboardDismissGesture = self.viewTap{
            keyboardDismissGesture.isEnabled = true
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let keyboardDismissGesture = self.viewTap{
            keyboardDismissGesture.isEnabled = false
        }
    }
}

//123456792
//123456789
