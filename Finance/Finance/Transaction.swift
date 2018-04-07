//
//  Transaction.swift
//  Finance
//
//  Created by Andrew/Paul on 11/29/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//  Code was copied from https://www.sitepoint.com/managing-data-in-ios-apps-with-sqlite/ and modified.
//

import Foundation

class Transaction {
    let transactionID: Int64?
    var transactionAmount: Int // amount in Cents (i.e. *100)
    var transactionDate: String // date in yyyy/MM/dd hh:mm:ss format
    var transactionCategory: Int64
    var transactionAccount: Int64
    var transactionVendor: String
    var transactionNote: String
    
    init(id: Int64) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd, hh:mm:ss"
        
        transactionID = id
        transactionAmount = 0
        transactionDate = dateFormatter.stringFromDate(NSDate())
        transactionCategory = 0
        transactionAccount = 0
        transactionVendor = ""
        transactionNote = ""
    }
    
    init(id: Int64, amount: Int, date: String, category: Int64, account: Int64, vendor: String, note: String) {
        transactionID = id
        transactionAmount = amount
        transactionDate = date
        transactionCategory = category
        transactionAccount = account
        transactionVendor = vendor
        transactionNote = note
    }
}