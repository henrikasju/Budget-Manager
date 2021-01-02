//
//  TopBarPageViewController.swift
//  Appsai
//
//  Created by Henrikas J on 11/03/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit
import Foundation

protocol PageViewProgressionDelegate {
    func updateProgressBar(step: Float)
    func isCurrentViewShowing(showing: Bool)
    func newViewAppeared(toLeft: Bool)
}

class TopBarPageViewController: UIPageViewController {
    
    let persistenceManager: PersistenceManager!
    
    required init?(coder: NSCoder) {
        self.persistenceManager = PersistenceManager.shared
        super.init(coder: coder)
    }
    
    fileprivate var items: [UIViewController] = []
    
    var progressionDelegate: PageViewProgressionDelegate!
    
    var currentIndex = 0
    var nextIndex = 0
    
    var firstItem: UIViewController!
    var lastItem: UIViewController!
    var currentItem: UIViewController!
    
    var currencySymbol: String = UserDefaults.standard.string(forKey: "CurrencyType") ?? "?"
    var dateFormat: String = (UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String) ?? "dd-MM-yyyy"
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentCurrencySymbol = UserDefaults.standard.string(forKey: "CurrencyType"){
            currencySymbol = currentCurrencySymbol
        }
        
        if let currentDateFormat = UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String{
            dateFormat = currentDateFormat
        }
        
        items.reverse()
        getCurrentMonthItems(update: true)
        items.reverse()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        dataSource = self
        setScrollAction(disableScroll: false)
//        delegate = self
        
        getCurrentMonthItems()
        
//        populateItems()
        
        
        items.reverse()
        
        print("Item Count: \(items.count)")
        
        if let firstViewController = items.last {
//            lastItem = firstViewController
            currentIndex = items.count-1
            
            if let itemView = firstViewController.view as? TopBarItem
            {
                itemView.setNavigationButtons(hideLeftButton: false, hideRightButton: true)
                itemView.enableNavigationButtons(enableLeft: true, enableRight: false)
            }
//            (firstViewController.view as! TopBarItem).setNavigationButtons(hideLeftButton: false, hideRightButton: true)
            currentItem = firstViewController
            firstItem = firstViewController
            progressionDelegate.isCurrentViewShowing(showing: true)
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        if let lastViewController = items.first {
            lastItem = lastViewController
            
            if let itemView = lastViewController.view as? TopBarItem
            {
                itemView.setNavigationButtons(hideLeftButton: true, hideRightButton: false)
            }
//            (lastViewController.view as! TopBarItem).setNavigationButtons(hideLeftButton: true, hideRightButton: false)
        }
        
        updateProgressionBar()
    }
    
    func getCurrentMonthItems(update: Bool = false){
        var itemsToAdd: [UIViewController] = []
        
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
            let days = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            
            let range = startOfMonthInt...currentDayInt
            for i in range{
                if let iDate: Date = Calendar.current.date(byAdding: .day, value: -i+1, to: date), let iDateWeekDayInt = Calendar.current.dateComponents([.weekday], from: iDate).weekday {
                    
                    let iDayTransactions = transactions.filter({ Calendar.current.isDate($0.date, inSameDayAs: iDate) })
                    
                    let iDateAsString = format.string(from: iDate)
                    let weekDay = ( Calendar.current.isDate(iDate, inSameDayAs: date) ? "Today" : days[iDateWeekDayInt-1] )
                    
//                    iDayTransactions.forEach({transaction in print("Date: \(transaction.date), Spent: \(transaction.transactionCost) ")})
                    
                    let vc = update ? items[i-1] : UIViewController()
                    if !update{
                        if iDayTransactions.count > 0{
                            let spentAmount: Double = iDayTransactions.reduce(0) { $0 + (($1 as Transaction).transactionCost < 0 ? ($1 as Transaction).transactionCost : 0) }
                            vc.view = TopBarItem(dateText: iDateAsString, dayText: weekDay, balanceAmount: spentAmount, balanceText: "Spent", currencySymbol: currencySymbol) as TopBarItem
                            
                        }else{
                            vc.view = TopBarItem(dateText: iDateAsString, dayText: weekDay, balanceAmount: 0, balanceText: "Spent", currencySymbol: currencySymbol) as TopBarItem
                        }
                        (vc.view as! TopBarItem).itemDelegate = self
                        itemsToAdd.append(vc)
                    }else{
                        if let view = vc.view as? TopBarItem{
                            let spentAmount: Double = iDayTransactions.reduce(0) { $0 + (($1 as Transaction).transactionCost < 0 ? ($1 as Transaction).transactionCost : 0) }
                            view.balanceAmountLabel.text = String(format: "%.2f", spentAmount) + currencySymbol
                            view.dayLabel.text = weekDay
                            view.dateLabel.text = iDateAsString
                        }
                        
                    }
                }
            }
 
        }
        
        if !update {
            items = itemsToAdd
        }
        

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
    
//    fileprivate func populateItems() {
//        let dates = ["10", "09", "08", "07", "06", "10", "09", "08", "07", "06"]
//        let days = ["Today", "Monday", "Saturday", "Friday", "Thursday", "Today", "Monday", "Saturday", "Friday", "Thursday"]
//        let balanceText = ["Spent", "Spent", "Spent", "Spent", "Spent", "Balance", "Spent", "Spent", "Spent", "Spent"]
//        let balanceAmount = ["31.08$", "21.08$", "11.08$", "01.08$", "03.12$", "31.08$", "21.08$", "11.08$", "01.08$", "03.12$" ]
//
//        for index in 0...dates.count-1 {
//            let c = createTopBarItemControler(date: dates[index], day: days[index], balance: balanceText[index], balanceAmount: balanceAmount[index])
//            items.append(c)
//        }
//    }
    
//    fileprivate func createTopBarItemControler(date: String, day: String, balance: String = "Balance", balanceAmount: String) -> UIViewController {
//        let c = UIViewController()
//        c.view = TopBarItem(dateText: date, dayText: day, balanceAmountText: balanceAmount, balanceText: balance)
//        (c.view as! TopBarItem).itemDelegate = self
//        return c
//    }
    
    func updateProgressionBar()
    {
        let showProgress: Float = (Float(currentIndex) / Float(items.count-1))
        progressionDelegate.updateProgressBar(step: showProgress)
    }
    
    func setItemsNavigationButtons(enableButtons: Bool, item: UIViewController)
    {
        if let itemView = item.view as? TopBarItem {
            if enableButtons {
                if item == firstItem {
                    itemView.setNavigationButtons(hideLeftButton: false, hideRightButton: true)
                    progressionDelegate.isCurrentViewShowing(showing: true)
                }else if item == lastItem {
                    itemView.setNavigationButtons(hideLeftButton: true, hideRightButton: false)
                    progressionDelegate.isCurrentViewShowing(showing: false)
                }else {
                    itemView.setNavigationButtons(hideLeftButton: false, hideRightButton: false)
                    progressionDelegate.isCurrentViewShowing(showing: false)
                }
            }else {
                itemView.setNavigationButtons(hideLeftButton: true, hideRightButton: true)
            }
        }
        
    }
    
    func NavigationButtonsCanInteract(interact: Bool, item: UIViewController)
    {
        if let itemView = item.view as? TopBarItem {
            if interact {
                itemView.enableNavigationButtons(enableLeft: true, enableRight: true)
            }else {
                itemView.enableNavigationButtons(enableLeft: false, enableRight: false)
            }
        }
    }
    
    func setScrollAction(disableScroll: Bool)
    {
        self.dataSource = disableScroll ? nil : self
        self.delegate = disableScroll ? nil : self
    }
    
    

}

// MARK: - DataSource

extension TopBarPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return nil
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
}

extension TopBarPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        
        if completed{
            print("Page View Completed")
            // 1 to left, -1 to right
            let viewIndexSide = currentIndex - nextIndex
            self.progressionDelegate.newViewAppeared(toLeft: (viewIndexSide == 1 ? true : false))
            currentIndex = nextIndex
            currentItem = items[currentIndex]
            
            
            setItemsNavigationButtons(enableButtons: true, item: currentItem )
            NavigationButtonsCanInteract(interact: true, item: currentItem )

            updateProgressionBar()
            
            self.view.isUserInteractionEnabled = true
        }else {
            print("Page VIEW FAILED")
            NavigationButtonsCanInteract(interact: true, item: currentItem)
            setItemsNavigationButtons(enableButtons: true, item: currentItem)
        }
        

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        print("MIGHT SWITCH")
        
        if let next = items.firstIndex(of: pendingViewControllers[0])
        {
            nextIndex = next

            setItemsNavigationButtons(enableButtons: false, item: pendingViewControllers[0])
            NavigationButtonsCanInteract(interact: false, item: pendingViewControllers[0])
            print("Disabling Buttons")
        }
    }
    

}

extension TopBarPageViewController: TopBarItemDelegate {
    
    func navigationButtonPressed(buttonPressed: String) {
        
        print("NAVIGATION BUTTON DELEGATE ACTIVATED!")
        self.view.isUserInteractionEnabled = false
        NavigationButtonsCanInteract(interact: false, item: currentItem )
    
        if buttonPressed == "LEFT" {
            if currentIndex > 0 {
                if let leftViewControllerIndex = items.firstIndex(of: items[currentIndex-1]) {
                    
                    self.pageViewController(self, willTransitionTo: [items[leftViewControllerIndex]])
                    
                    let hanlderBlock: (Bool) -> Void = {_ in
                        print("<- LEFT BUTTON TRANSITION")
                        self.pageViewController(self, didFinishAnimating: true, previousViewControllers: [self.items[leftViewControllerIndex]], transitionCompleted: true)
                    }
                    
                    setViewControllers([items[leftViewControllerIndex]], direction: .reverse, animated: true,
                                       completion: hanlderBlock)
                }
            }
        }else if buttonPressed == "RIGHT" {
            if currentIndex < items.count-1
            {
                if let rightViewControllerIndex = items.firstIndex(of: items[currentIndex+1]) {
                    
                    self.pageViewController(self, willTransitionTo: [items[rightViewControllerIndex]])
                    
                    let hanlderBlock: (Bool) -> Void = {_ in
                        print("RIGHT BUTTON TRANSITION ->")
                        self.pageViewController(self, didFinishAnimating: true, previousViewControllers: [self.items[rightViewControllerIndex]], transitionCompleted: true)
                    }
                    
                    setViewControllers([items[rightViewControllerIndex]], direction: .forward, animated: true,
                                       completion: hanlderBlock)
                }
            }
        }
    }
    
    
}


