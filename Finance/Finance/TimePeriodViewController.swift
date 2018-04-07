//
//  TimePeriodViewController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/2/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class TimePeriodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let timePeriodText = ["Weekly", "Bi-weekly", "Monthly", "Yearly"]
    var currentSelection = NSIndexPath(forRow: 0, inSection: 0)
    var mainTBC = MainTabBarController()
    
    @IBAction func done(sender: UIBarButtonItem) {
        // update time period selection setting
        FinanceDB.instance.updateTimePeriod(currentSelection.row)
        
        // refresh global app settings
        mainTBC.settings = FinanceDB.instance.getSettings()[0]
        
        // return to settings scene
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showParentScene(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTBC = presentingViewController as! MainTabBarController
        
        currentSelection = NSIndexPath(forRow: mainTBC.settings.timePeriod, inSection: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainTBC.timePeriods.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transaction History Time Period"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timePeriodCell")
        cell!.textLabel!.text = timePeriodText[indexPath.row]
        
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
