//
//  DateFormatTableViewController.swift
//  Appsai
//
//  Created by Henrikas J on 12/05/2020.
//  Copyright © 2020 Henrikas J. All rights reserved.
//

import UIKit

class DateFormatSettingsTableViewController: UITableViewController {
    
    let dateFormatValues: [(name: String, value: String)] =   [("Month / Day / Year","MM-dd-yyyy"),
                                                               ("Year / Month / Day","yyyy-MM-dd"),
                                                               ("Day / Month / Year","dd-MM-yyyy")]
    
    var selectedCell: IndexPath = IndexPath(row: 0, section: 0)
    let sectionCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dateFormatValues.forEach({date in print("Date: \(date.name), value: \(date.value)")})
        
        if let currentDateFormatValue = UserDefaults.standard.dictionary(forKey: "DateFormat")?.first?.value as? String{
            selectedCell = IndexPath(row: getDateFormatIndexByValue(dateFormatValue: currentDateFormatValue), section: 0)
        }
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getDateFormatIndexByValue(dateFormatValue: String) -> Int {
        for (i, format) in dateFormatValues.enumerated(){
//            print("[\(i)]: \(format.name) = \(format.value)")
            if(format.value == dateFormatValue) { return i }
        }
        return 0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dateFormatValues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "DateFormatOption")
        
        cell.textLabel?.text = dateFormatValues[indexPath.row].name
        
        if indexPath.row == self.selectedCell.row {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let existingCell = tableView.cellForRow(at: indexPath) {
            if indexPath != selectedCell{
                if let existingPreviousCell = tableView.cellForRow(at: self.selectedCell){
                    existingPreviousCell.accessoryType = .none
                }
                self.selectedCell = indexPath
                let selectedFormat = dateFormatValues[indexPath.row]
                UserDefaults.standard.set([selectedFormat.name: selectedFormat.value], forKey: "DateFormat")
                existingCell.accessoryType = .checkmark
            }
            existingCell.setSelected(false, animated: true)
        }
    }
    
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
