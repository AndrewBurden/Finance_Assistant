//
//  AccountViewController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/10/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    var mainTBC = MainTabBarController()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceField: UITextField!
    @IBOutlet weak var accountTitleField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    
    @IBAction func dismissScene(sender: AnyObject) {
        if sender === saveButton {
            
            if accountTitleField.text == "" || balanceField.text == "" {
                let alertController = UIAlertController(title: "Unable to Create Account", message: "You must fill out both the Account Title and Starting Balance fields in order to create an account.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            if mainTBC.isNewAccount {
                FinanceDB.instance.addAccount(accountTitleField.text!, balance: Int(Double(balanceField.text!)!*100))
            }
            else {
                FinanceDB.instance.updateAccount(mainTBC.accounts[mainTBC.accountToEditIndex].accountID!, newName: accountTitleField.text!)
            }
            mainTBC.accounts = FinanceDB.instance.getAccounts()
            dismissViewControllerAnimated(true, completion: nil)
        }
        if sender === deleteButton {
            
            if mainTBC.accounts.count == 1 {
                let alertController = UIAlertController(title: "Unable to Delete", message: "You must have at least one account at all times.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            // if the account has transactions associated with it, don't allow delete
            if FinanceDB.instance.accountHasTransactions(mainTBC.accounts[mainTBC.accountToEditIndex].accountID!) {
                // create the alert window
                let alertController = UIAlertController(title: "Unable to Delete Account", message: "This account is associated with past transactions and cannot be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                // create the alert window
                let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: UIAlertControllerStyle.Alert)
            
                // create buttons
                let nowAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                    {(alertAction: UIAlertAction!) in FinanceDB.instance.deleteAccount(self.mainTBC.accounts[self.mainTBC.accountToEditIndex].accountID!); self.mainTBC.accounts = FinanceDB.instance.getAccounts(); self.dismissViewControllerAnimated(true, completion: nil)})
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
                alertController.addAction(nowAction)
                alertController.addAction(cancelAction)
            
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
        if sender === cancelButton {
            dismissViewControllerAnimated(true, completion: nil)
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
        
        mainTBC = presentingViewController as! MainTabBarController
        
        if mainTBC.isNewAccount {
            currencyLabel.hidden = false
            balanceField.hidden = false
            balanceLabel.hidden = false
            deleteButton.hidden = true
            totalBalanceLabel.hidden = true
            navBar.topItem!.title = "New Account"
            
            currencyLabel.text = mainTBC.symbols[mainTBC.settings.currency]
        }
        else {
            currencyLabel.hidden = true
            balanceField.hidden = true
            balanceLabel.hidden = true
            totalBalanceLabel.hidden = false
            navBar.topItem!.title = "Edit Account"
            
            accountTitleField.text = mainTBC.accounts[mainTBC.accountToEditIndex].accountName
            
            let balance = NSDecimalNumber(string: String(abs(mainTBC.accounts[mainTBC.accountToEditIndex].accountBalance))) / 100.0
            
            var plusMinus = ""
            
            if mainTBC.accounts[mainTBC.accountToEditIndex].accountBalance < 0 {
                plusMinus = "-"
            }
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            var balanceString = formatter.stringFromNumber(balance)!
            balanceString = balanceString.substringFromIndex(balanceString.startIndex.advancedBy(1))
            
            totalBalanceLabel.text = "Balance: \(plusMinus)\(mainTBC.symbols[mainTBC.settings.currency])\(balanceString)"
            
        }
    }
}
