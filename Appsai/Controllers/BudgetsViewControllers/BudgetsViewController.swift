//
//  BudgetsViewController.swift
//  Appsai
//
//  Created by Henrikas J on 05/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

// TODO: Total budget and budget cell subtraction is made with all transaction assign to category, not current month!

import UIKit

class BudgetsViewController: UIViewController {
    
    let persistenceManager: PersistenceManager!
    
    required init?(coder: NSCoder) {
        self.persistenceManager = PersistenceManager.shared
        super.init(coder: coder)
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewTitleBalanceLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var budgetCountdownLabel: UILabel!
    @IBOutlet weak var budgetsTableView: UITableView!
    
    var categories: [TransactonCategory] = []
    var colors: [Color] = []
    var currentMonthTransactions: [Transaction] = []
    
    var currencySymbol: String = "$"
    var dateFormat: String = "dd-MM-yyyy"
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedCell = budgetsTableView.indexPathForSelectedRow{
            budgetsTableView.cellForRow(at: selectedCell)?.setSelected(false, animated: true)
        }
        
        getCurrentMonthTransactions()
        getCategories()
        self.budgetsTableView.reloadData()
        
        if let currentCurrencySymbol = UserDefaults.standard.string(forKey: "CurrencyType") {
            currencySymbol = currentCurrencySymbol
        }
           
        if let currentDateFormatValue = UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String{
            dateFormat = currentDateFormatValue
        }
        
        setupTopBar()
    }
    
    var categoriesV: [BudgetCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetsTableView.delegate = self
        budgetsTableView.dataSource = self

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        colors = persistenceManager.fetch(Color.self)
    }
    
    func setupTopBar(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = self.dateFormat
        let formattedDate = format.string(from: date)
        
        format.dateFormat = "dd"
        
        var startOfMonthComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: date)
        
        guard let startOfMonthDate = Calendar(identifier: .gregorian).date(from: startOfMonthComponents) else{
            return
        }
        
        var endOfMonthComponents = DateComponents()
        endOfMonthComponents.second = -1
        endOfMonthComponents.month = 1
        guard let lastDateOfMonth = Calendar(identifier: .gregorian).date(byAdding: endOfMonthComponents, to: startOfMonthDate) else{
            return
        }
        
        guard let endOfMonthDay = Int(format.string(from: lastDateOfMonth)), let currentDay = Int(format.string(from: date)) else{
            return
        }

        
        let daysLeftUntilMonthEnd: Int = endOfMonthDay-currentDay + 1
        
//        print("First day of month: \(format.string(from: startOfMonthDate)), End of month day: \(format.string(from: lastDateOfMonth))")
//        print("Days left until the end of the month: \(daysLeftUntilMonthEnd)")
        var totalBalance: Double = 0.0
        
        for category in categories {
            totalBalance += category.givenBudget
            if let transactions = category.transactions?.array as? [Transaction]{
                let filteredTransactions = transactions.filter({ ( $0.date >= startOfMonthDate ) && ( $0.date <= date ) })
                for transaction in filteredTransactions{
                    totalBalance += transaction.transactionCost
                }
            }
        }
        
        dateLabel.text = formattedDate
        let budgetCounttDownLabel: String = (daysLeftUntilMonthEnd > 1 ? ( String(daysLeftUntilMonthEnd) + " days left" ) : "Last day")
        budgetCountdownLabel.text = budgetCounttDownLabel
        balanceAmountLabel.text = String(format: "%.2f", totalBalance) + currencySymbol
    }
    
    func getCurrentMonthTransactions(){
        
    }
    
    func printDetailedCategory(category: TransactonCategory) {
        print("Category name: \(category.name), imageName: \(category.iconName), givenBudget: \(category.givenBudget), color: \(category.color), Transactons: \(category.transactions)")
    }
    
    func createCategories(){
        let gasColor = UIColor(red: 70/255.0, green: 96/255.0, blue: 190/255.0, alpha: 1)
        let snackColor = UIColor(red: 134/255.0, green: 50/255.0, blue: 139/255.0, alpha: 1)
        let foodColor = UIColor(red: 225/255.0, green: 110/255.0, blue: 56/255.0, alpha: 1)
        let cinemaColor = UIColor(red: 73/255.0, green: 162/255.0, blue: 90/255.0, alpha: 1)
        
        let gasCategory: BudgetCategory = BudgetCategory(name: "Gas", color: gasColor, imageName: "car.fill", givenBudget: 40.0)
        let foodCategory: BudgetCategory = BudgetCategory(name: "Food", color: foodColor, imageName: "cart.fill", givenBudget: 120.0)
        let cinemaCategory: BudgetCategory = BudgetCategory(name: "Cinema", color: cinemaColor, imageName: "film.fill", givenBudget: 15.0)
        let snacksCategory: BudgetCategory = BudgetCategory(name: "Snacks", color: snackColor, imageName: "sun.max.fill", givenBudget: 20.0)
        
        let gasTransactions = createTransations(category: gasCategory)
        let foodTransactions = createTransations(category: foodCategory)
        let cinemaTransactions = createTransations(category: cinemaCategory)
        let snacksTransactions = createTransations(category: snacksCategory)
        
        gasCategory.setTransactions(transactions: gasTransactions)
        foodCategory.setTransactions(transactions: foodTransactions)
        cinemaCategory.setTransactions(transactions: cinemaTransactions)
        snacksCategory.setTransactions(transactions: snacksTransactions)
        
        categoriesV.append(gasCategory)
        categoriesV.append(foodCategory)
        categoriesV.append(cinemaCategory)
        categoriesV.append(snacksCategory)
    }
    
    func createTransations(category: BudgetCategory) -> [TransactionV]
    {
        var tempTransactions: [TransactionV] = []
        
        switch category.name {
        case "Gas":
            let tran1 = TransactionV(transactionPlace: "Neste", transactionCost: -30.47, assignedCategory: category)
            tempTransactions.append(tran1)
            
        case "Food":
            let tran2 = TransactionV(transactionPlace: "Maxima", transactionCost: -11.22, assignedCategory: category)
            let tran4 = TransactionV(transactionPlace: "At UAB Kaunas Forum Cinemas", transactionCost: -31200.14, assignedCategory: category)
            let tran5 = TransactionV(transactionPlace: "Rimi", transactionCost: -1.98, assignedCategory: category)
            let tran7 = TransactionV(transactionPlace: "Silas", transactionCost: -23.48, assignedCategory: category)
            let tran10 = TransactionV(transactionPlace: "Maxima", transactionCost: -23.48, assignedCategory: category)
            
            tempTransactions.append(tran2)
            tempTransactions.append(tran4)
            tempTransactions.append(tran5)
            tempTransactions.append(tran7)
            tempTransactions.append(tran10)
        case "Snacks":
            let tran6 = TransactionV(transactionPlace: "Saldus majai", transactionCost: -3.28, assignedCategory: category)
            let tran8 = TransactionV(transactionPlace: "IKI", transactionCost: -1.98, assignedCategory: category)
            
            tempTransactions.append(tran6)
            tempTransactions.append(tran8)
        case "Cinema" :
            let tran3 = TransactionV(transactionPlace: "Formum Cinema", transactionCost: -7.00, assignedCategory: category)
            let tran9 = TransactionV(transactionPlace: "Forum Cinema", transactionCost: -3.28, assignedCategory: category)
            
            tempTransactions.append(tran3)
            tempTransactions.append(tran9)
        default:
            break
        }
        
        return tempTransactions
    }
    
    func updateCategory(category: TransactonCategory ,name: String, imageName: String, givenBudget: Double, colorR: Float, colorG: Float, colorB: Float) {
        category.name = name
        category.iconName.name = imageName
        category.givenBudget = givenBudget
        category.color.setColor(red: colorR, green: colorG, blue: colorB, alpha: 1.0)
        
        self.persistenceManager.saveContext()
    }
    
    func deleteCategory(category: TransactonCategory){
        category.transactions?.forEach({ transaction in self.persistenceManager.delete((transaction as! Transaction))})
        self.persistenceManager.delete(category)
    }
    
    func getCategories(){
        let categories = persistenceManager.fetch(TransactonCategory.self)
        self.categories = categories
    }
    
    func getCategoryLeftAmount(category: TransactonCategory) -> Double{
        var amount: Double = category.givenBudget
        
        if let transactions = category.transactions?.array as? [Transaction] {
            let date = Date()
            
            var startOfMonthComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: date)
            
            guard let startOfMonthDate = Calendar(identifier: .gregorian).date(from: startOfMonthComponents) else{
                return 0.0
            }
            
            let filteredTransactions = transactions.filter({ ( $0.date >= startOfMonthDate ) && ( $0.date <= date ) })
            for transaction in filteredTransactions{
                amount += transaction.transactionCost
            }
        }
        
        return amount
    }
    
    

}

extension BudgetsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Budget Cell") as! BudgetTableViewCell
                    
        let category = self.categories[indexPath.row]
        
        let budgetAmount: Double = getCategoryLeftAmount(category: category)
        
        let cellColor = UIColor(red: CGFloat(category.color.red), green: CGFloat(category.color.green), blue: CGFloat(category.color.blue), alpha: CGFloat(category.color.alpha))
//        let cellSymbol = (UIApplication.shared.delegate as! AppDelegate).getCurrencySymbol(rowIndex: UserDefaults.standard.integer(forKey: "CurrencyType"))
        cell.setData(categoryImageName: category.iconName.name, categoryColor: cellColor, categoryLabel: category.name, givenBudget: budgetAmount, currencySymbol: currencySymbol)
                    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print(indexPath)
            deleteCategory(category: categories[indexPath.row])
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            setupTopBar()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label = ""
        let backgroundColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)

        label = "Budget Distribution"
        return BudgetTabelHeaderSection(sectionLabel: label, sectionLabelColor: .black, backgroundColor: backgroundColor)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    
}

extension BudgetsViewController: UIAdaptivePresentationControllerDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCellSegue"{
            let childVc = segue.destination as? BudgetFormViewController
            if let indexPath = budgetsTableView.indexPathForSelectedRow{
                print("Edit cell at \(indexPath)")
                childVc?.editingCategory = categories[indexPath.row]
                print("Editing cell name: \(categories[indexPath.row].name)")
                segue.destination.presentationController?.delegate = self
            }
//            childVc?.editingCategory =
        }else if segue.identifier == "AddCellSegue" {
            segue.destination.presentationController?.delegate = self
            navigationController?.presentationController?.delegate = self
        }
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.viewWillAppear(true)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // Did dismissed
        print("Dismiss Hapenned")
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("Tried to dismiss")
    }
}

//jei menesuje yra 31 diena ir pirma diena yra 1, kiek dienu liko iki kito men pirmos dienos?
//31-1 = 30, + 1 = 31
//31-31 = 0, + 1 = 1

