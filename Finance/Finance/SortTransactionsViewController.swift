//
//  SortTransactionsViewController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/8/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class SortTransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let sortByText = ["Amount (Lowest First)", "Amount (Highest First)", "Category (A-Z)", "Category (Z-A)", "Date (Newest First)", "Date (Oldest First)"]
    var currentSelection = NSIndexPath(forRow: 0, inSection: 0)
    var mainTBC = MainTabBarController()
    
    @IBAction func dismissScene(sender: UIBarButtonItem) {
        // update currency selection setting
        FinanceDB.instance.updateSortBy(currentSelection.row)
        
        // refresh global app settings
        mainTBC.settings = FinanceDB.instance.getSettings()[0]
        
        // return to settings scene
        dismissViewControllerAnimated(true, completion: nil)
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
        
        mainTBC = presentingViewController as! MainTabBarController
        
        currentSelection = NSIndexPath(forRow: mainTBC.settings.sortBy, inSection: 0)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTBC.sortByOptions.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sort Transactions By"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sortCell")
        cell!.textLabel!.text = sortByText[indexPath.row]
        
        if indexPath.section == currentSelection.section && indexPath.row == currentSelection.row {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let oldCell = tableView.cellForRowAtIndexPath(currentSelection)
        oldCell!.accessoryType = UITableViewCellAccessoryType.None
        
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        currentSelection = indexPath
    }
    
}
