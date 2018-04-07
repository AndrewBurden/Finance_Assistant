//
//  TransactionsViewController.swift
//  Finance
//
//  Created by Paul on 12/1/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var transactions = [Transaction]()
    var categories = [Category]()
    var accounts = [Account]()
    var mainTBC = MainTabBarController()
    let dateFormatter = NSDateFormatter()
    let dbDateFormatter = NSDateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var noTransactionsLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBAction func showNewScene(sender: AnyObject) {
        if sender === addButton {
            mainTBC.isNewTransaction = true
            performSegueWithIdentifier("toNewTransaction", sender: sender)
        }
    }
    
    @IBAction func enableEditing(sender: UIBarButtonItem) {
        if sender.title! == "Edit" {
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

        dateFormatter.dateFormat = "MMMM d, yyyy"
        dbDateFormatter.dateFormat = "yyyy/MM/dd"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTBC = parentViewController as! MainTabBarController
        
        mainTBC.accounts = FinanceDB.instance.getAccounts()
        
        let queryReturn = FinanceDB.instance.getTransactions(mainTBC.sortByOptions[mainTBC.settings.sortBy], timePeriod: mainTBC.timePeriods[mainTBC.settings.timePeriod])
        
        transactions = queryReturn.0
        categories = queryReturn.1
        accounts = queryReturn.2
        
        if transactions.count == 0 {
            tableView.hidden = true
            noTransactionsLabel.hidden = false
            editButton.enabled = false
        }
        else {
            tableView.hidden = false
            noTransactionsLabel.hidden = true
            editButton.enabled = true
            tableView.reloadData()
        }
        
        editButton.title = "Edit"
        tableView.editing = false
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (mainTBC.settings.timePeriod) {
        case 0:
            return "Transactions from the Past Week"
        case 1:
            return "Transactions from the Past Two Weeks"
        case 2:
            return "Transactions from the Past Month"
        case 3:
            return "Transactions from the Past Year"
        default:
            return "Transactions"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let amount = NSDecimalNumber(string: String(abs(transactions[indexPath.row].transactionAmount))) / 100.0
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        var amountString = formatter.stringFromNumber(amount)!
        amountString = amountString.substringFromIndex(amountString.startIndex.advancedBy(1))
        var plusMinus: String
        if transactions[indexPath.row].transactionAmount < 0 {
            plusMinus = "-"
        }
        else {
            plusMinus = "+"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transactionCell")!
        cell.textLabel!.text = "\(plusMinus)\(mainTBC.symbols[mainTBC.settings.currency])\(amountString) - \(accounts[indexPath.row].accountName)"
        
        let dateString = transactions[indexPath.row].transactionDate
        let date = dbDateFormatter.dateFromString(dateString)!
        
        cell.detailTextLabel!.text = "\(dateFormatter.stringFromDate(date)) - \(transactions[indexPath.row].transactionNote) - \(categories[indexPath.row].categoryName)"
        
        cell.imageView!.image = mainTBC.categoryIcons[categories[indexPath.row].categoryIcon]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        mainTBC.isNewTransaction = false
        mainTBC.transactionToEdit = transactions[indexPath.row]
        performSegueWithIdentifier("toNewTransaction", sender: tableView)
    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.tableView.editing) {
            return UITableViewCellEditingStyle.Delete;
        }
        
        return UITableViewCellEditingStyle.None;
    }
 
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            mainTBC.transactionToEdit = transactions[indexPath.row]
            FinanceDB.instance.deleteTransaction(self.mainTBC.transactionToEdit.transactionID!, amount: self.mainTBC.transactionToEdit.transactionAmount, account: self.mainTBC.transactionToEdit.transactionAccount)
            transactions.removeAtIndex(indexPath.row)
            categories.removeAtIndex(indexPath.row)
            accounts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            if transactions.count == 0 {
                tableView.hidden = true
                noTransactionsLabel.hidden = false
                tableView.editing = false
                editButton.title = "Edit"
                editButton.enabled = false
            }
            
            mainTBC.accounts = FinanceDB.instance.getAccounts()
        }
    }

}
