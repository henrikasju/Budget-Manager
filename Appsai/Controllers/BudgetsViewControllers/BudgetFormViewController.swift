//
//  BudgetFormViewController.swift
//  Appsai
//
//  Created by Henrikas J on 05/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

// TODO: Fix budget size, get choped everytime on update, rounding issue

import UIKit

class BudgetFormViewController: UIViewController {

    let persistenceManager: PersistenceManager!
    
    var editingCategory: TransactonCategory?
    
    required init?(coder: NSCoder) {
        self.persistenceManager = PersistenceManager.shared
        super.init(coder: coder)
    }
    
    @IBOutlet weak var ContainerTableView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var containerViewController: BudgetFormTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

                
        if editingCategory != nil {
            addButton.setTitle("Update", for: .normal)
        }
        
        // Do any additional setup after loading the view.
        
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        
        self.presentationController?.delegate?.presentationControllerWillDismiss?(self.presentationController!)
        self.dismiss(animated: true)
        self.presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        if let containerVc = containerViewController {
            guard let categoryName: String = containerVc.categoryNameTextField.text else {
                return
            }

            guard let categoryBudget: String = containerVc.budgetSizeTextField.text else {
                return
            }

            guard let colorIndex: IndexPath = containerVc.selectedColorIndex else {
                return
            }

            guard let logoIndex: IndexPath = containerVc.selectedLogoIndex else {
                return
            }

            guard let note: String = containerVc.notesTextView.text else {
                return
            }
            
            guard let color: Color = persistenceManager.fetch(Colors.self).first?.colors?.array[colorIndex.row] as? Color else {
                return
            }
            
            guard let iconName: CategoryIconName = persistenceManager.fetch(CategoryIconNames.self).first?.iconNames?.array[logoIndex.row] as? CategoryIconName else {
                return
            }

            if !categoryName.isEmpty && Double(categoryBudget.dropLast()) != nil && !colorIndex.isEmpty && !logoIndex.isEmpty {
                print("Valid Input")
                
                let date = ( editingCategory == nil ? Date() : editingCategory!.date )
                
                let category: TransactonCategory = (editingCategory == nil ? TransactonCategory(context: self.persistenceManager.context): editingCategory!)

                category.name = categoryName
                category.givenBudget = Double(categoryBudget.dropLast())!
                category.iconName = iconName
                category.color = color
                category.note = note
                category.date = date

                
                self.persistenceManager.saveContext()
                self.presentationController?.delegate?.presentationControllerWillDismiss?(self.presentationController!)
                self.dismiss(animated: true)
                self.presentationController?.delegate?.presentationControllerDidDismiss?(self.presentationController!)
            }else{
                print("Invalid Input")
            }

            print("Recieved Input[ Name: \(categoryName), Budget: \(categoryBudget), ColorIndex: \(colorIndex), LogoIndex: \(logoIndex), Note: \(note)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryTableSegue" {
            self.containerViewController = segue.destination as? BudgetFormTableViewController
            if editingCategory != nil{
                self.containerViewController?.editingCategory = self.editingCategory
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

