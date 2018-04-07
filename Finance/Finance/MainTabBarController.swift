//
//  MainTabBarController.swift
//  Finance
//
//  Created by Andrew/Paul on 12/1/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let categoryIcons: [UIImage] =
        [
            UIImage(named: "Apple Watch-100.png")!,
            UIImage(named: "Bag Back View-100.png")!,
            UIImage(named: "Banknotes-100.png")!,
            UIImage(named: "Barcode-100.png")!,
            UIImage(named: "Check Book-100.png")!,
            UIImage(named: "Checkout-100.png")!,
            UIImage(named: "Cheese-100.png")!,
            UIImage(named: "Chef Hat-100.png")!,
            UIImage(named: "Chip-100.png")!,
            UIImage(named: "Christmas Mitten-100.png")!,
            UIImage(named: "Coins-100.png")!,
            UIImage(named: "Diamond-100.png")!,
            UIImage(named: "Fan 2-100.png")!,
            UIImage(named: "French Fries-100.png")!,
            UIImage(named: "German Hat-100.png")!,
            UIImage(named: "Glasses-100.png")!,
            UIImage(named: "Hammer-100.png")!,
            UIImage(named: "HDD-100.png")!,
            UIImage(named: "Money Bag-100.png")!,
            UIImage(named: "Purchase Order-100.png")!,
            UIImage(named: "Rice Bowl-100.png")!,
            UIImage(named: "Scissors-100.png")!,
            UIImage(named: "SD-96.png")!,
            UIImage(named: "Shirt-100.png")!,
            UIImage(named: "Umbrella-100.png")!,
            UIImage(named: "Wallet-100.png")!,
            UIImage(named: "Wheelbarrow-100.png")!
        ]
    
    let symbols = [
        "$",
        "Lek",
        "؋",
        "ƒ",
        "ман",
        "Br",
        "BZ$",
        "$b",
        "KM",
        "P",
        "лв",
        "R$",
        "៛",
        "¥",
        "₡",
        "kn",
        "₱",
        "Kč",
        "kr",
        "RD$",
        "£",
        "€",
        "¢",
        "Q",
        "L",
        "Ft",
        "kr",
        "Rp",
        "﷼",
        "₪",
        "J$",
        "₩",
        "₭",
        "ден",
        "RM",
        "₨",
        "₮",
        "MT",
        "C$",
        "₦",
        "B/.",
        "Gs",
        "S/.",
        "₱",
        "zł",
        "lei",
        "руб",
        "Дин.",
        "S",
        "R",
        "CHF",
        "NT$",
        "฿",
        "TT$",
        "₴",
        "$U",
        "Bs",
        "₫",
        "Z$"
    ]
    
    let sortByOptions = ["[amount] DESC", "[amount] ASC", "[category] DESC", "[category] ASC", "[date] DESC", "[date] ASC"]
    
    let timePeriods = [7.0, 14.0, 30.0, 365.0]
    
    var settings = Setting()
    var isNewAccount = false
    var isNewCategory = false
    var isNewTransaction = false
    var accountToEditIndex = 0
    var categoryToEditIndex = NSIndexPath(forRow: 0, inSection: 0)
    var categoryType = 0
    var transactionToEdit = Transaction(id: 0)
    var accounts = [Account]()
    var categories = [
        [Category](),
        [Category]()
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FinanceDB.instance.setDefaultSettings(0, sortBy: 0, timePeriod: 0)
        
        settings = FinanceDB.instance.getSettings()[0]
        accounts = FinanceDB.instance.getAccounts()
        categories = [
            FinanceDB.instance.getCategories(0),
            FinanceDB.instance.getCategories(1)
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
