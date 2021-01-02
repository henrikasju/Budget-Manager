//
//  DetailsViewController.swift
//  Appsai
//
//  Created by Henrikas J on 17/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

// TODO: editing cells used force unwraping
// TODO: tapGesture is allways working, even if keyboard is not presented


import UIKit

class TransactionFormViewController: UIViewController {
    
    let persistenceManager: PersistenceManager!
    
    required init?(coder: NSCoder) {
        self.persistenceManager = PersistenceManager.shared
        super.init(coder: coder)
    }
    
    enum Cells {
        static let Input = "inputCell"
        static let Cost = "costCell"
        static let Color = "colorOptionCell"
        static let List = "listOptionCell"
        static let Note = "noteCell"
    }
    
    @IBOutlet weak var budgetTabelView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var viewName: UILabel! // Transaction view
    
    var currentTextViewBottomY: CGFloat = .zero
    
    let currencySymbol: String = UserDefaults.standard.string(forKey: "CurrencyType") ?? "?"
    
    let decimalSeperator: Character = NumberFormatter().decimalSeparator.first ?? "."
    
    var dateFormat: String = (UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String) ?? "dd-MM-yyyy"
    
    let tableSectionCount: Int = 4
    let tableSectionCellCount: Int = 1
    
    var transactionName: String?
    var transactionCost: Double?
    var transactionCostOperator: Int?
    var transactionCategory: TransactonCategory?
    var transactionCategoryIndex: Int?
    var transactionNote: String?
    
    var categories: [TransactonCategory] = []
    
    var editingTransaction: Transaction?
    var editingFlag: Bool = false
    
    var viewTap: UITapGestureRecognizer? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetTabelView.delegate = self
        budgetTabelView.dataSource = self
        // Do any additional setup after loading the view.
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        self.view.addGestureRecognizer(viewTap)
//        viewTap.isEnabled = false
        self.viewTap = viewTap
        
        budgetTabelView.keyboardDismissMode = .onDrag
        
        getCategories()
        
        if editingTransaction != nil {
            loadEditingData()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let keyboard_height = (self.view.frame.height - keyboardRect.height)
        if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) && (currentTextViewBottomY > (self.view.frame.height - keyboardRect.height)) {
            let difference = currentTextViewBottomY - keyboard_height + 10
            view.frame.origin.y = -difference
        }else{
            view.frame.origin.y = 0
            currentTextViewBottomY = .zero
        }
    }
    
    @objc func dissmisKeyboard(){
        self.view.endEditing(true)
        view.frame.origin.y = 0
    }
    
    func getCategories(){
        let categories = persistenceManager.fetch(TransactonCategory.self)
        self.categories = categories
    }
    
    func loadEditingData() {
        
        guard let transactionName = editingTransaction?.transactionPlace else {
            return
        }

        guard let transactionCost = editingTransaction?.transactionCost else {
            return
        }

        guard let transactionCategory = editingTransaction?.category else {
            return
        }

        guard let transactionNote = editingTransaction?.note else {
            return
        }
        
        self.transactionName = transactionName
        transactionCost >= 0 ? (self.transactionCost = transactionCost) : (self.transactionCost = transactionCost * Double(-1))
        transactionCost >= 0 ? (self.transactionCostOperator = 1) : (self.transactionCostOperator = 0)
        self.transactionCategory = transactionCategory
        self.transactionCategoryIndex = categories.firstIndex(of: transactionCategory)
        self.transactionNote = transactionNote
        
        self.editingFlag = true
        addButton.setTitle("Update", for: .normal)
        dayLabel.text = "Edit"
    }
    
    @IBAction func DismissButtonPressed(_ sender: Any) {
        self.presentationController?.delegate?.presentationControllerWillDismiss?(self.presentationController!)
        self.dismiss(animated: true)
        self.presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        
        guard let transactionName = (budgetTabelView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InputTableViewCell)?.inputTextField.text else{
            return
        }
        
        guard let transactionCostCell = (budgetTabelView.cellForRow(at: IndexPath(row: 0, section: 1)) as? CostTableViewCell), let transactionCostStringRaw = transactionCostCell.costTextField.text, let transactionCostOperator = (transactionCostCell.operatorSegmentControl.selectedSegmentIndex == 0 ? -1 : 1) else {
            return
        }
        
        guard let transactionCategory = (budgetTabelView.cellForRow(at: IndexPath(row: 0, section: 2)) as? ListOptionTableViewCell)?.selectedCategory else{
            return
        }
        
        guard let transactionNote = (budgetTabelView.cellForRow(at: IndexPath(row: 0, section: 3)) as? NoteTableViewCell)?.noteTextView.text else{
            return
        }
        
        let transactionCostString: String = ( transactionCostStringRaw.contains(currencySymbol) ? String(transactionCostStringRaw.dropLast()) : transactionCostStringRaw )
        
        if !transactionName.isEmpty && Double(transactionCostString) != nil {
            print("Valid Input")

            let date = ( editingTransaction == nil ? Date() : editingTransaction!.date )


//            let category: TransactonCategory = (editingCategory == nil ? TransactonCategory(context: self.persistenceManager.context): editingCategory!)
            
            let transaction: Transaction = (editingTransaction == nil ? Transaction(context: self.persistenceManager.context) : editingTransaction!)
            
            transaction.transactionPlace = transactionName
            transaction.transactionCost = ( Double(transactionCostString)! * Double(transactionCostOperator) )
            transaction.category = transactionCategory
            transaction.note = transactionNote
            transaction.date = date

            self.persistenceManager.saveContext()
            self.presentationController?.delegate?.presentationControllerWillDismiss?(self.presentationController!)
            self.dismiss(animated: true)
            self.presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
        }else{
            print("Invalid Input")
        }

        print("Recieved Input[ Name: \(transactionName), Cost: \(transactionCostString), Category: \(transactionCategory.name), Note: \(transactionNote)")
    
    }
    
}

extension TransactionFormViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSectionCellCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 55
        }else if indexPath.section == 2{
            return 110
        }else if indexPath.section == 3{
            return 215
        }
        return 45.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Transaction name"
        } else if section == 1{
            return "Transaction cost"
        }else if section == 2{
            return "Category"
        }else{
            return "Notes"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Input) as! InputTableViewCell
            cell.inputTableViewCellDelegate = self
            cell.setCell(inputPlaceholder: "Market place")
            if editingFlag {cell.inputTextField.text = self.transactionName}
            
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Cost) as! CostTableViewCell
            cell.setData(costInputPlaceHolder: "0.00" + currencySymbol, selectedOperator: .subtract, currencySymbol: currencySymbol )
            cell.costTableViewCellDelegate = self
            
            if editingFlag {
                cell.costTextField.text = String(format: "%.2f", self.transactionCost!) + currencySymbol
                cell.operatorSegmentControl.selectedSegmentIndex = self.transactionCostOperator!
                cell.operatorSegmentControl.sendActions(for: UIControl.Event.valueChanged)}
            
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.List) as! ListOptionTableViewCell
            cell.setCell(categories: categories)
            
            if editingFlag {
                cell.selectedCategory = self.transactionCategory
                cell.selectedCategory = self.transactionCategory
                cell.ListOption.selectRow(self.transactionCategoryIndex!, inComponent: 0, animated: false)
            }
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Note) as! NoteTableViewCell
            cell.noteTableViewCellDelegate = self
            if editingFlag {cell.noteTextView.text = self.transactionNote; editingFlag = false}
            
            return cell
        }else{
            let cell = UITableViewCell()
            
            return cell
        }
    }
    
    
}

extension TransactionFormViewController: InputTableViewCellDelegate, CostTableViewCellDelegate, NoteTableViewCellDelegate{

    func getTextViewBottomYCoordinate(view: UIView) {
        currentTextViewBottomY = view.convert(view.bounds, to: self.view).maxY
    }
}

