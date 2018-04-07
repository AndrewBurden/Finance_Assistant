//
//  NewTransactionViewController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/2/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class NewTransactionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var vendorField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var mainTBC = MainTabBarController()
    var multiplier = -1.0
    var categoryOrAccount = false // false: category    true: account
    var selectedCategory = 0
    var selectedAccount = 0
    let textDateFormatter = NSDateFormatter()
    let dbDateFormatter = NSDateFormatter()
    var selectedDate = NSDate()
    var dateWasSelected = false
    
    @IBAction func showParentScene(sender: AnyObject) {
        hideKeyboard()
        
        if sender === saveButton {
            
            if amountField.text == "" || dateField.text == "" || categoryField.text == "" || accountField.text == "" {
                let alertController = UIAlertController(title: "Unable to Save", message: "The Amount, Date, Category, and Account fields must be completed before saving.", preferredStyle: UIAlertControllerStyle.Alert)
                
                // create a button
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                
                // add the button into the alert window
                alertController.addAction(defaultAction)
                
                //display the alert window
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            hideKeyboard()
            var amount = Double(amountField.text!)!
            amount = amount * 100.0 * multiplier
            
            if mainTBC.isNewTransaction {
            // save the transaction to the database
            
                let id = FinanceDB.instance.addTransaction(Int(amount), date: dbDateFormatter.stringFromDate(selectedDate), category: mainTBC.categories[typeSegControl.selectedSegmentIndex][selectedCategory].categoryID!, account: mainTBC.accounts[selectedAccount].accountID!, vendor: vendorField.text!, note: noteField.text!)
            
                print("Transaction was committed successfully. ID: \(id)")
            }
            else {
                FinanceDB.instance.updateTransaction(mainTBC.transactionToEdit.transactionID! , amount: Int(amount), oldAmount: mainTBC.transactionToEdit.transactionAmount, date: dbDateFormatter.stringFromDate(selectedDate), category: mainTBC.categories[typeSegControl.selectedSegmentIndex][selectedCategory].categoryID!, account: mainTBC.accounts[selectedAccount].accountID!, vendor: vendorField.text!, note: noteField.text!)
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        else if sender === cancelButton {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else if sender === deleteButton {
            // create the alert window
            let alertController = UIAlertController(title: "Delete Transaction", message: "Are you sure you want to delete this transaction?", preferredStyle: UIAlertControllerStyle.Alert)
                
            // create buttons
            let nowAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
                {(alertAction: UIAlertAction!) in FinanceDB.instance.deleteTransaction(self.mainTBC.transactionToEdit.transactionID!, amount: self.mainTBC.transactionToEdit.transactionAmount, account: self.mainTBC.transactionToEdit.transactionAccount); self.dismissViewControllerAnimated(true, completion: nil)})
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                
            alertController.addAction(nowAction)
            alertController.addAction(cancelAction)
                
            //display the alert window
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func typeSelectionChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            multiplier = -1.0
        }
        else {
            multiplier = 1.0
        }
        picker.reloadAllComponents()
        categoryField.text = ""
    }
    
    @IBAction func doneWasPressed(sender: UIButton) {
        subView.hidden = true
    }
    
    @IBAction func textFieldEditingBegan(sender: AnyObject) {
        if sender === amountField {
            
            subView.hidden = true
        }
        else if sender === dateField  {
            
            subView.hidden = true
        }
        else if sender === categoryField {
            categoryOrAccount = false
            categoryField.resignFirstResponder()
            picker.reloadAllComponents()
            subView.hidden = false
        }
        else if sender === accountField {
            categoryOrAccount = true
            accountField.resignFirstResponder()
            picker.reloadAllComponents()
            subView.hidden = false
        }
        else if sender === vendorField {
            
            subView.hidden = true
        }
        else if sender === noteField {
            
            subView.hidden = true
        }
    }
    @IBAction func textFieldEditingEnded(sender: AnyObject) {
        hideKeyboard()
    }
    
    func hideKeyboard() {
        self.view.resignFirstResponder()
        amountField.resignFirstResponder()
        dateField.resignFirstResponder()
        categoryField.resignFirstResponder()
        accountField.resignFirstResponder()
        vendorField.resignFirstResponder()
        noteField.resignFirstResponder()
    }
    
    @IBAction func fieldButtonWasPressed(sender: AnyObject) {
        if sender === dateButton {
            if !dateWasSelected {
                dateField.text = textDateFormatter.stringFromDate(NSDate())
                dateWasSelected = true
            }
            hideKeyboard()
            datePicker.hidden = false
            picker.hidden = true
            subView.hidden = false
        }
        else if sender === categoryButton {
            if selectedCategory == 0 {
                categoryField.text = mainTBC.categories[typeSegControl.selectedSegmentIndex][selectedCategory].categoryName
            }
            categoryOrAccount = false
            hideKeyboard()
            picker.reloadAllComponents()
            datePicker.hidden = true
            picker.hidden = false
            subView.hidden = false
            picker.selectRow(selectedCategory, inComponent: 0, animated: true)
        }
        else if sender === accountButton {
            if selectedAccount == 0 {
                accountField.text = mainTBC.accounts[selectedAccount].accountName
            }
            categoryOrAccount = true
            hideKeyboard()
            picker.reloadAllComponents()
            datePicker.hidden = true
            picker.hidden = false
            subView.hidden = false
            picker.selectRow(selectedAccount, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func dateWasChanged(sender: UIDatePicker) {
        selectedDate = sender.date
        dateField.text = textDateFormatter.stringFromDate(sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textDateFormatter.dateFormat = "MMMM d, yyyy"
        dbDateFormatter.dateFormat = "yyyy/MM/dd"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        mainTBC = presentingViewController as! MainTabBarController
        currencyLabel.text = mainTBC.symbols[mainTBC.settings.currency]
        subView.hidden = true
        picker.reloadAllComponents()
        picker.selectRow(0, inComponent: 0, animated: true)
        
        if mainTBC.isNewTransaction {
            dateWasSelected = false
            multiplier = -1.0
            categoryOrAccount = false // false: category    true: account
            selectedCategory = 0
            selectedAccount = 0
            selectedDate = NSDate()
            dateWasSelected = false
            typeSegControl.selectedSegmentIndex = 0
            deleteButton.hidden = true
            navBar.topItem!.title = "New Transaction"
        }
        else {
            let amount = NSDecimalNumber(string: String(abs(mainTBC.transactionToEdit.transactionAmount))) / 100.0
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            var amountString = formatter.stringFromNumber(amount)!
            amountString = amountString.substringFromIndex(amountString.startIndex.advancedBy(1))
            amountField.text = amountString
            
            if mainTBC.transactionToEdit.transactionAmount < 0 {
                typeSegControl.selectedSegmentIndex = 0
            }
            else {
                typeSegControl.selectedSegmentIndex = 1
            }
            
            datePicker.setDate(dbDateFormatter.dateFromString(mainTBC.transactionToEdit.transactionDate)!, animated: true)
            selectedDate = datePicker.date
            dateField.text = textDateFormatter.stringFromDate(selectedDate)
            dateWasSelected = true
            
            // search for the category for this transaction
            for i in 0 ..< mainTBC.categories[typeSegControl.selectedSegmentIndex].count {
                if mainTBC.transactionToEdit.transactionCategory == mainTBC.categories[typeSegControl.selectedSegmentIndex][i].categoryID {
                    selectedCategory = i
                    break
                }
            }
            categoryField.text = mainTBC.categories[typeSegControl.selectedSegmentIndex][selectedCategory].categoryName
            
            // search for the account for this transaction
            for i in 0 ..< mainTBC.accounts.count {
                if mainTBC.transactionToEdit.transactionAccount == mainTBC.accounts[i].accountID {
                    selectedAccount = i
                    break
                }
            }
            
            accountField.text = mainTBC.accounts[selectedAccount].accountName
            
            
            vendorField.text = mainTBC.transactionToEdit.transactionVendor
            noteField.text = mainTBC.transactionToEdit.transactionNote
            
            deleteButton.hidden = false
            
            navBar.topItem!.title = "Edit Transaction"
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if categoryOrAccount { // account is selected
            return mainTBC.accounts.count
        }
        else { // category is selected
            return mainTBC.categories[typeSegControl.selectedSegmentIndex].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryOrAccount { // account is selected
            return mainTBC.accounts[row].accountName
        }
        else { // category is selected
            return mainTBC.categories[typeSegControl.selectedSegmentIndex][row].categoryName
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if categoryOrAccount { // account
            accountField.text = mainTBC.accounts[row].accountName
            selectedAccount = row
        }
        else { // category
            categoryField.text = mainTBC.categories[typeSegControl.selectedSegmentIndex][row].categoryName
            selectedCategory = row
        }
    }
}
