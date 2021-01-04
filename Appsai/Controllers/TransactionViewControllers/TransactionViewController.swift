//
//  MainViewController.swift
//  Appsai
//
//  Created by Henrikas J on 11/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//
// Geguziws 20plus minus

import UIKit

class TransactionViewController: UIViewController {
    
    let persistenceManager: PersistenceManager!
    
    required init?(coder: NSCoder) {
        self.persistenceManager = PersistenceManager.shared
        super.init(coder: coder)
    }
    
    var topBarVC: TopBarPageViewController?
    
    var currentDayIndex: Int = 0

    var transactions: [Transaction] = []
    var categories: [TransactonCategory] = []
    
    var currentMonthTransactions: [[Transaction]] = []

    var progressValue: Float = 1

    @IBOutlet weak var BudgetTableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var currencySymbol: String = UserDefaults.standard.string(forKey: "CurrencyType") ?? "?"
    var dateFormat: String = (UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String) ?? "dd-MM-yyyy"
    
    
    override func viewWillAppear(_ animated: Bool) {
        getTransaction()
        getTransactionCategories()
        getCurrentMonthTransactions()
        
        if let currentCurrencySymbol = UserDefaults.standard.string(forKey: "CurrencyType"){
            currencySymbol = currentCurrencySymbol
        }
        
        if let currentDateFormat = UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String{
            dateFormat = currentDateFormat
        }
        
        if let vc = topBarVC{
            vc.viewWillAppear(true)
        }
        BudgetTableView.reloadData()
        
        if categories.count > 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        BudgetTableView.delegate = self
        BudgetTableView.dataSource = self
             
//        createCategories()
//        fillTransactionsFromCategories()
        
        let progressBarCornerRadius: CGFloat = 4.0

        progressBar.layer.cornerRadius = progressBarCornerRadius
        progressBar.layer.masksToBounds = true
        
//        progressBar.transform = CGAffineTransform(rotationAngle: .pi)
        
        progressBar.layer.sublayers![1].cornerRadius = progressBarCornerRadius
        progressBar.subviews[1].clipsToBounds = true
                
        
//        transactions.forEach({ transaction in printDetailedTransaction(transaction: transaction)})
    }
    
    func printDetailedTransaction(transaction: Transaction){
        print("Transaction name: \(transaction.transactionPlace), cost: \(transaction.transactionCost), category: \(transaction.category.name)")
    }
    
    
    func getTransaction(){
        let transactions = persistenceManager.fetch(Transaction.self)
        self.transactions = transactions
    }
    
    func deleteTransaction(transaction: Transaction){
        self.persistenceManager.delete(transaction)
    }
    
    
    func getTransactionCategories(){
        let categories = persistenceManager.fetch(TransactonCategory.self)
        self.categories = categories
        
        print("Categories")
        categories.forEach({print($0.name)})
    }
    
    func getCurrentMonthTransactions(){
        var currentMonthTransactions: [[Transaction]] = []
        
        let date = Date()
        
        let format = DateFormatter()
        format.dateFormat = "dd"
        
        let startOfMonthComponents = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: date)
        
        var endOfMonthComponents = DateComponents()
        endOfMonthComponents.second = -1
        endOfMonthComponents.month = 1
        
        if let startOfMonth = Calendar(identifier: .gregorian).date(from: startOfMonthComponents), let startOfMonthInt = Int(format.string(from: startOfMonth)), let currentDayInt = Int(format.string(from: date)){
         
            let transactions: [Transaction] = getTransactionsBetweenDates(startDate: startOfMonth, endDate: date)
            
            format.dateFormat = self.dateFormat
            
            let range = startOfMonthInt...currentDayInt
            for i in range{
                
                if let iDate: Date = Calendar.current.date(byAdding: .day, value: -i+1, to: date) {
                
                    let iDayTransactions = transactions.filter({ Calendar.current.isDate($0.date, inSameDayAs: iDate) })
                    
                    currentMonthTransactions.append(iDayTransactions)
                
                }
                
            }
            
        }
        
        self.currentMonthTransactions = currentMonthTransactions
        transactions = currentMonthTransactions.last!
    }
    
    func getTransactionsBetweenDates(startDate: Date, endDate: Date) -> [Transaction]{
        
        let transactions: [Transaction] = persistenceManager.fetch(Transaction.self)
        
        if transactions.count > 0 {

            var filteredTransaction = transactions.filter({ ($0.date >= startDate) && ($0.date <= endDate)  })
            filteredTransaction.sort(by: { ($0 as Transaction).date.compare(($1 as Transaction).date) == .orderedDescending  })
            return filteredTransaction


        }
        
        return []
    }
    
    

}

extension TransactionViewController: PageViewProgressionDelegate {
    func newViewAppeared(toLeft: Bool) {
        print("Move to \(toLeft ? "Left" : "Right")")
        if toLeft {
            self.currentDayIndex += 1
        }else{
            self.currentDayIndex -= 1
        }
        
        UIView.transition(with: self.BudgetTableView,
                          duration: 0.4,
        options: .transitionFlipFromTop,
        animations: { self.BudgetTableView.reloadData() })
    }
    
    
    func isCurrentViewShowing(showing: Bool) {
        self.navigationItem.title = showing ? "Current Transactions" : "Past Transactions"
//        UIView.transition(with: self.BudgetTableView,
//                          duration: 0.4,
//        options: .transitionFlipFromTop,
//        animations: { self.BudgetTableView.reloadData() })
        print("SHOEINH")
    }
    
    func updateProgressBar(step: Float) {
        print("Changing step from \(progressValue) to \(step)")
        progressValue = step
        progressBar.setProgress(progressValue, animated: true)
    }
    
}

// TABLE VIEW
extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.transactions.count
        print("CurrentDayIndex: \(currentDayIndex)")
        return self.currentMonthTransactions[currentDayIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Transaction Cell") as! TransactionTableViewCell
//        let transaction = self.transactions[indexPath.row]
        
        let transaction = self.currentMonthTransactions[currentDayIndex][indexPath.row]
        
        let categoryColor = UIColor(red: CGFloat(transaction.category.color.red), green: CGFloat(transaction.category.color.green), blue: CGFloat(transaction.category.color.blue), alpha: CGFloat(transaction.category.color.alpha))

        cell.setData(categoryImageName: transaction.category.iconName.name, categoryColor: categoryColor, categoryLabel: transaction.category.name, transactionLabel: transaction.transactionPlace, transactionCost: transaction.transactionCost, currencySymbol: currencySymbol)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backgroundColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)

        return BudgetTabelHeaderSection(sectionLabel: "Transactions", sectionLabelColor: .black, backgroundColor: backgroundColor)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print(indexPath)
            deleteTransaction(transaction: self.currentMonthTransactions[currentDayIndex][indexPath.row])
            self.currentMonthTransactions[currentDayIndex].remove(at: indexPath.row )
            topBarVC?.viewWillAppear(true)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
}


// SEGUES

extension TransactionViewController: UIAdaptivePresentationControllerDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTransactionCellSegue"{
            let childVc = segue.destination as? TransactionFormViewController
            if let indexPath = BudgetTableView.indexPathForSelectedRow{
                print("Edit cell at \(indexPath)")
                childVc?.editingTransaction = currentMonthTransactions[currentDayIndex][indexPath.row]
                print("Editing cell name: \(currentMonthTransactions[currentDayIndex][indexPath.row].transactionPlace)")
                segue.destination.presentationController?.delegate = self
            }
//            childVc?.editingCategory =
        }else if segue.identifier == "addTransactionCellSegue" {
            segue.destination.presentationController?.delegate = self
            navigationController?.presentationController?.delegate = self
        }else if let vc = segue.destination as? TopBarPageViewController{
            vc.progressionDelegate = self
            self.topBarVC = vc
        }
        else if segue.identifier == "addTransaction" {
            print("MEME")
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
