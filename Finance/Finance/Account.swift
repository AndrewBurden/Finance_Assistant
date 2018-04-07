//
//  Account.swift
//  Finance
//
//  Created by Andrew/Paul on 12/01/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//  Code was copied from https://www.sitepoint.com/managing-data-in-ios-apps-with-sqlite/ and modified.
//

import Foundation

class Account {
    let accountID: Int64?
    var accountName: String
    var accountBalance: Int
    
    init(id: Int64) {
        accountID = id
        accountName = ""
        accountBalance = 0
    }
    
    init(id: Int64, name: String, balance: Int) {
        accountID = id
        accountName = name
        accountBalance = balance
    }
}