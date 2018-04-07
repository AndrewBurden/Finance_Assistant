//
//  SettingsViewController.swift
//  Finance
//
//  Created by Paul on 12/1/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    let sections = ["User Interface", "Account Management"]
    var items = [
        ["Time Period", "Sort Transactions", "Currency Symbol"],
        ["Add New Account..."]
    ]
    var mainTBC = MainTabBarController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTBC = parentViewController as! MainTabBarController
        
        items[1] = ["Add New Account..."]
        for account in mainTBC.accounts {
            items[1].append(account.accountName)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell")
        cell!.textLabel!.text = items[indexPath.section][indexPath.row]
        
        if indexPath.section == 1 && indexPath.row == 0 {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        else {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (items[indexPath.section][indexPath.row]) {
        case "Time Period":
            performSegueWithIdentifier("toTimePeriod", sender: tableView)
        case "Sort Transactions":
            performSegueWithIdentifier("toSortTransactions", sender: tableView)
        case "Currency Symbol":
            performSegueWithIdentifier("toCurrencySymbol", sender: tableView)
        case "Add New Account...":
            mainTBC.isNewAccount = true
            performSegueWithIdentifier("toAccount", sender: tableView)
        default:
            mainTBC.isNewAccount = false
            mainTBC.accountToEditIndex = indexPath.row - 1 // subtract 1 because "Add new acount" is 1st
            performSegueWithIdentifier("toAccount", sender: tableView)
        }
    }

}
