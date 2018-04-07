//
//  CategoriesViewController.swift
//  Finance
//
//  Created by Paul on 12/1/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var mainTBC = MainTabBarController()
    var categories = [[Category](), [Category]()]
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noCategoriesLabel: UILabel!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    
    @IBAction func showNewScene(sender: AnyObject) {
        if sender === addButton {
            mainTBC.isNewCategory = true
            mainTBC.categoryType = typeSegControl.selectedSegmentIndex
            performSegueWithIdentifier("toNewCategory", sender: sender)
        }
    }
    
    @IBAction func typeSelectionChanged(sender: AnyObject) {
        if mainTBC.categories[typeSegControl.selectedSegmentIndex].count == 0 {
            tableView.hidden = true
            noCategoriesLabel.hidden = false
            editButton.enabled = false
        }
        else {
            tableView.hidden = false
            noCategoriesLabel.hidden = true
            tableView.reloadData()
            editButton.enabled = true
        }
    }
    
    @IBAction func enableEditing(sender: UIBarButtonItem) {
        if sender.title! == "Edit"{
            tableView.editing = true
            sender.title = "Done"
        }
        else {
            tableView.editing = false
            sender.title = "Edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTBC = parentViewController as! MainTabBarController
    
        editButton.title = "Edit"
        tableView.editing = false
    
        typeSelectionChanged(typeSegControl)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTBC.categories[typeSegControl.selectedSegmentIndex].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if typeSegControl.selectedSegmentIndex == 0 {
            return "Expense Category List"
        }
        else {
            return "Income Category List"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell")!
        let categoryImage = mainTBC.categoryIcons[mainTBC.categories[typeSegControl.selectedSegmentIndex][indexPath.row].categoryIcon]
        cell.textLabel!.text = mainTBC.categories[typeSegControl.selectedSegmentIndex][indexPath.row].categoryName
        cell.imageView!.image = categoryImage

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        mainTBC.isNewCategory = false
        mainTBC.categoryToEditIndex = NSIndexPath(forRow: indexPath.row, inSection: typeSegControl.selectedSegmentIndex)
        mainTBC.categoryType = typeSegControl.selectedSegmentIndex
        performSegueWithIdentifier("toNewCategory", sender: tableView)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.tableView.editing) {
            return UITableViewCellEditingStyle.Delete;
        }
        
        return UITableViewCellEditingStyle.None;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if FinanceDB.instance.categoryHasTransactions(mainTBC.categories[typeSegControl.selectedSegmentIndex][indexPath.row].categoryID!) {
                // create the alert window
                let alertController = UIAlertController(title: "Unable to Delete Category", message: "This category is associated with past transactions and cannot be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
            }
            else if mainTBC.categories[0].count == 1 || mainTBC.categories[1].count == 1 {
                let alertController = UIAlertController(title: "Unable to Delete", message: "You must have at least one category in both the income and expense sections.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            else {
                FinanceDB.instance.deleteCategory(mainTBC.categories[typeSegControl.selectedSegmentIndex][indexPath.row].categoryID!)
                mainTBC.categories[typeSegControl.selectedSegmentIndex].removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                if mainTBC.categories[typeSegControl.selectedSegmentIndex].count == 0 {
                    tableView.hidden = true
                    noCategoriesLabel.hidden = false
                    tableView.editing = false
                    editButton.title = "Edit"
                    editButton.enabled = false
                }
            }
        }
    }

}
