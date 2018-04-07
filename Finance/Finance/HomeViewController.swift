//
//  HomeViewController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/1/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var netLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var mainTBC = MainTabBarController()
    
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
        
        switch (mainTBC.settings.timePeriod) {
            case 0:
                titleLabel.text = "All Account Summary - Past Week"
            case 1:
                titleLabel.text = "All Account Summary - Past Two Weeks"
            case 2:
                titleLabel.text = "All Account Summary - Past Month"
            case 3:
                titleLabel.text = "All Account Summary - Past Year"
            default:
                titleLabel.text = "All Account Summary"
        }
        
        let totals = FinanceDB.instance.getTransactionTotals(mainTBC.timePeriods[mainTBC.settings.timePeriod])
        
        let accountTotals = FinanceDB.instance.getAccountTotals()
        
        let income = NSDecimalNumber(string: String(abs(totals.0))) / 100.0
        let expenses = NSDecimalNumber(string: String(abs(totals.1))) / 100.0
        var net = income - expenses
        let assets = NSDecimalNumber(string: String(abs(accountTotals))) / 100.0
        var plusMinusNet = ""
        var plusMinusTotal = ""
        
        if net < 0 {
            plusMinusNet = "-"
            net = net * NSDecimalNumber(int: -1)
        }
        
        if accountTotals < 0 {
            plusMinusTotal = "-"
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        var incomeString = formatter.stringFromNumber(income)!
        var expenseString = formatter.stringFromNumber(expenses)!
        var netString = formatter.stringFromNumber(net)!
        var assetsString = formatter.stringFromNumber(assets)!
        incomeString = incomeString.substringFromIndex(incomeString.startIndex.advancedBy(1))
        expenseString = expenseString.substringFromIndex(expenseString.startIndex.advancedBy(1))
        netString = netString.substringFromIndex(netString.startIndex.advancedBy(1))
        assetsString = assetsString.substringFromIndex(assetsString.startIndex.advancedBy(1))
        
        incomeLabel.text = "\(mainTBC.symbols[mainTBC.settings.currency])\(incomeString)"
        expenseLabel.text = "\(mainTBC.symbols[mainTBC.settings.currency])\(expenseString)"
        
        netLabel.text = "\(plusMinusNet)\(mainTBC.symbols[mainTBC.settings.currency])\(netString)"
        totalLabel.text = "\(plusMinusTotal)\(mainTBC.symbols[mainTBC.settings.currency])\(assetsString)"


    }
}
