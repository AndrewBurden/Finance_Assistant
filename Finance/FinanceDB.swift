//
//  FinanceDB.swift
//  Finance
//
//  Created by Paul on 12/6/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import SQLite
import Foundation

class FinanceDB {
    static let instance = FinanceDB()
    private let db: Connection?
    
    private let transactions = Table("transaction")
    private let tID = Expression<Int64>("tID")
    private let tAmount = Expression<Int>("tAmount")
    private let tDate = Expression<String>("tDate")
    private let tCategory = Expression<Int64>("tCategory")
    private let tAccount = Expression<Int64>("tAccount")
    private let tVendor = Expression<String>("tVendor")
    private let tNote = Expression<String>("tNote")
    
    private let accounts = Table("account")
    private let aID = Expression<Int64>("aID")
    private let aName = Expression<String>("aname")
    private let aBalance = Expression<Int>("aBalance")
    
    private let categories = Table("category")
    private let cID = Expression<Int64>("cID")
    private let cName = Expression<String>("cName")
    private let cType = Expression<Int>("cType")
    private let cIcon = Expression<Int>("cIcon")
    
    private let settings = Table("setting")
    private let currency = Expression<Int>("currency")
    private let sortBy = Expression<Int>("sortBy")
    private let timePeriod = Expression<Int>("timePeriod")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Finance.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        //dropTable("transaction")
        //dropTable("account")
        //dropTable("category")
        createTables()
    }
    
    func dropTable(tableName: String) {
        do {
            try db!.execute(
                "BEGIN TRANSACTION;" +
                "DROP TABLE [\(tableName)];" +
                "COMMIT TRANSACTION;"
            )
        }
        catch {
            print("Unable to execute drop command.")
        }
    }
    
    func createTables() {
        do {
            try db!.run(transactions.create(ifNotExists: true) { table in
                table.column(tID, primaryKey: true)
                table.column(tAmount)
                table.column(tDate)
                table.column(tCategory)
                table.column(tAccount)
                table.column(tVendor)
                table.column(tNote)
                })
            try db!.run(accounts.create(ifNotExists: true) { table in
                table.column(aID, primaryKey: true)
                table.column(aName, unique: true)
                table.column(aBalance)
                })
            try db!.run(categories.create(ifNotExists: true) { table in
                table.column(cID, primaryKey: true)
                table.column(cName, unique: true)
                table.column(cType)
                table.column(cIcon)
                })
            try db!.run(settings.create(ifNotExists: true) { table in
                table.column(currency)
                table.column(sortBy)
                table.column(timePeriod)
                })
        } catch {
            print("Unable to create table")
        }
    }
    
    /*
     *
     * Transaction Queries
     *
     */
    func addTransaction(amount: Int, date: String, category: Int64, account: Int64, vendor: String, note: String) -> Int64? {
        let id: Int64?
        do {
            let insert = transactions.insert(tAmount <- amount, tDate <- date, tCategory <- category, tAccount <- account, tVendor <- vendor, tNote <- note)
            id = try db!.run(insert)
        } catch {
            print("Insert failed")
            return -1
        }
        
        do {
            
        }
        
        let account = accounts.filter(account == aID)
        do {
            let accountUpdate = account.update(aBalance <- aBalance + amount)
            if try db!.run(accountUpdate) > 0 {
                return id
            }
        } catch {
            print("Update of account failed; \(error)")
        }
        
        return -1
    }
    
    func getTransactions() -> [Transaction] {
        var transactions = [Transaction]()
        
        do {
            for transaction in try db!.prepare(self.transactions) {
                transactions.append(Transaction(
                    id: transaction[tID],
                    amount: transaction[tAmount],
                    date: transaction[tDate],
                    category: transaction[tCategory],
                    account: transaction[tAccount],
                    vendor: transaction[tVendor],
                    note: transaction[tNote])
                )
            }
        } catch {
            print("Select failed")
        }
        
        return transactions
    }
    
    func getTransactions(orderBy: String, timePeriod: Double) -> ([Transaction], [Category], [Account]) {
        var transactions = [Transaction]()
        var transactionCategories = [Category]()
        var transactionAccounts = [Account]()
        let dateLimitString = getDateLimitString(timePeriod)
        var query: QueryType
        
        switch orderBy {
        case "[amount] ASC":
            query = self.transactions
                .join(categories, on: cID == tCategory).join(accounts, on: aID == tAccount)
                .filter(tDate > dateLimitString)
                .order(tAmount.asc)
        case "[amount] DESC":
            query = self.transactions
                .join(categories, on: cID == tCategory).join(accounts, on: aID == tAccount)
                .filter(tDate > dateLimitString)
                .order(tAmount.desc)
        case "[date] DESC":
            query = self.transactions
                .join(categories, on: cID == tCategory).join(accounts, on: aID == tAccount)
                .filter(tDate > dateLimitString)
                .order(tDate.desc)
        case "[category] ASC":
            query = self.transactions
                .join(categories, on: cID == tCategory).join(accounts, on: aID == tAccount)
                .filter(tDate > dateLimitString)
                .order(tCategory.asc)
        case "[category] DESC":
            query = self.transactions
                .join(categories, on: cID == tCategory).join(accounts, on: aID == tAccount)
                .filter(tDate > dateLimitString)
                .order(tCategory.desc)
        default:
            query = self.transactions
                .join(categories, on: cID == tCategory).join(accounts, on: aID == tAccount)
                .filter(tDate > dateLimitString)
                .order(tDate.asc)
        }
        
        do {
            for transaction in try db!.prepare(query){
                transactions.append(Transaction(
                    id: transaction[tID],
                    amount: transaction[tAmount],
                    date: transaction[tDate],
                    category: transaction[tCategory],
                    account: transaction[tAccount],
                    vendor: transaction[tVendor],
                    note: transaction[tNote])
                )
                transactionCategories.append(Category(
                    id: transaction[cID],
                    name: transaction[cName],
                    type: transaction[cType],
                    icon: transaction[cIcon]))
                transactionAccounts.append(Account(
                    id: transaction[aID],
                    name: transaction[aName],
                    balance: transaction[aBalance]))
            }
        } catch {
            print("Select failed: \(error)")
        }
        
        return (transactions, transactionCategories, transactionAccounts)
    }
    
    func updateTransaction(id: Int64, amount: Int, oldAmount: Int, date: String, category: Int64, account: Int64, vendor: String, note: String) -> Bool {
        let transaction = transactions.filter(id == tID)
        do {
            let update = transaction.update([tAmount <- amount, tDate <- date, tCategory <- category, tAccount <- account, tVendor <- vendor, tNote <- note])
            if try db!.run(update) > 0 {
                print("Update of transaction successful")
            }
        } catch {
            print("Update of transaction failed; \(error)")
        }
        
        let account = accounts.filter(account == aID)
        do {
            let accountUpdate = account.update(aBalance <- aBalance - oldAmount + amount)
            if try db!.run(accountUpdate) > 0 {
                return true
            }
        } catch {
            print("Update of account failed; \(error)")
        }
        
        return false
    }
    
    func deleteTransaction(id: Int64, amount: Int, account: Int64) -> Bool {
        do {
            let transaction = transactions.filter(tID == id)
            try db!.run(transaction.delete())
            print("Delete of transaction was successful")
        } catch {
            print("Delete of transaction failed; \(error)")
        }
        
        let account = accounts.filter(account == aID)
        do {
            let accountUpdate = account.update(aBalance <- aBalance - amount)
            if try db!.run(accountUpdate) > 0 {
                return true
            }
        } catch {
            print("Update of account failed; \(error)")
        }
        return false
    }
    
    func getTransactionTotals(timePeriod: Double) -> (Double, Double){
        var totalIncome = 0.0
        var totalExpenses = 0.0
        let limitDate = getDateLimitString(timePeriod)
        
        do {
            let income = try db!.prepare("SELECT total(tAmount) FROM [transaction] WHERE tAmount >= 0 AND tDate > '\(limitDate)'")
            totalIncome = try income.scalar() as! Double
        } catch {
            print("Could not get total income. \(error)")
        }
        
        do {
            let expenses = try db!.prepare("SELECT total(tAmount) FROM [transaction] WHERE tAmount < 0 AND tDate > '\(limitDate)'")
            totalExpenses = try expenses.scalar() as! Double
        } catch {
            print("Could not get total expenses. \(error)")
        }
        
        return (totalIncome, totalExpenses)
    }
    
    /*
     *
     * Category Queries
     *
     */
    
    // Get all categories of the selected type. 0: Expense  1: Income
    func getCategories(type: Int) -> [Category] {
        var categories = [Category]()
        
        let query = self.categories.select(*).filter(cType == type)
        
        do {
            for category in try db!.prepare(query) {
                categories.append(Category(
                    id: category[cID],
                    name: category[cName],
                    type: category[cType],
                    icon: category[cIcon])
                )
            }
        } catch {
            print("Select failed")
        }
        
        return categories
    }
    
    func addCategory(name: String, type: Int, icon: Int) -> Int64? {
        do {
            let insert = categories.insert(cName <- name, cType <- type, cIcon <- icon)
            let categoryId = try db!.run(insert)
            
            return categoryId
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func updateCategory(id: Int64, newName: String, newIcon: Int, newType: Int) -> Bool {
        let category = categories.filter(id == cID)
        do {
            let update = category.update([cName <- newName, cIcon <- newIcon, cType <- newType])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update of category failed; \(error)")
        }
        
        return false
    }
    
    func deleteCategory(id: Int64) -> Bool {
        do {
            let category = categories.filter(cID == id)
            try db!.run(category.delete())
            return true
        } catch {
            print("Delete of category failed; \(error)")
        }
        return false
    }
    
    func categoryHasTransactions(id: Int64) -> Bool {
        let query = transactions.select(*).filter(tCategory == id)
        do {
            for _ in try db!.prepare(query) {
                return true
            }
        } catch {
            print("Delete of category failed; \(error)")
        }
        
        return false
    }
    
    /*
     *
     * Account Queries
     *
     */
    
    func addAccount(name: String, balance: Int) -> Int64? {
        do {
            let insert = accounts.insert(aName <- name, aBalance <- balance)
            let aId = try db!.run(insert)
            
            return aId
        } catch {
            print("Insert of account failed; \(error)")
            return -1
        }
    }
    
    func getAccounts() -> [Account] {
        var accounts = [Account]()
        
        let query = self.accounts.select(*)
        
        do {
            for account in try db!.prepare(query) {
                accounts.append(Account(
                    id: account[aID],
                    name: account[aName],
                    balance: account[aBalance])
                )
            }
        } catch {
            print("Select of accounts failed; \(error)")
        }
        
        return accounts
    }
    
    func updateAccount(id: Int64, newName: String) -> Bool {
        let account = accounts.filter(id == aID)
        do {
            let update = account.update([aName <- newName])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update of account failed; \(error)")
        }
        
        return false
    }
    
    func deleteAccount(id: Int64) -> Bool {
        do {
            let account = accounts.filter(aID == id)
            try db!.run(account.delete())
            return true
        } catch {
            print("Delete of account failed; \(error)")
        }
        return false
    }

    func accountHasTransactions(id: Int64) -> Bool {
        let query = transactions.select(*).filter(tAccount == id)
        do {
            for _ in try db!.prepare(query) {
                return true
            }
        } catch {
            print("Delete of account failed; \(error)")
        }
        
        return false
    }
    
    func getAccountTotals() -> (Double){
        var totalBalance = 0.0
        
        do {
            let balances = try db!.prepare("SELECT total(aBalance) FROM [account]")
            totalBalance = try balances.scalar() as! Double
        } catch {
            print("Could not get total balance \(error)")
        }
        
        return totalBalance
    }
    
    /*
     *
     * Setting Queries
     *
     */
    // returns an array containing a single Setting object
    func getSettings() -> [Setting] {
        var settings = [Setting]()
        
        do {
            for setting in try db!.prepare(self.settings) {
                settings.append(Setting(
                    currency: setting[currency],
                    sortBy: setting[sortBy],
                    timePeriod: setting[timePeriod])
                )}
        } catch {
            print("Select failed")
        }
        
        return settings
    }
    
    // Updates the "currency" index value in the settings table
    func updateCurrency(newCurrency: Int) -> Bool {
        do {
            let update = settings.update([
                currency <- newCurrency
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    // Updates the "time period" index value in the settings table
    func updateTimePeriod(newTimePeriod: Int) -> Bool {
        do {
            let update = settings.update([
                timePeriod <- newTimePeriod
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    // Updates the "sort by" index value in the settings table
    func updateSortBy(newSortBy: Int) -> Bool {
        do {
            let update = settings.update([
                sortBy <- newSortBy
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    // used only to create the first and only row in the settings table
    func setDefaultSettings(currency: Int, sortBy: Int, timePeriod: Int) {
        do {
            let insert = settings.insert(self.currency <- currency, self.sortBy <- sortBy, self.timePeriod <- timePeriod)
            try db!.run(insert)
        } catch {
            print("Insert of default settings failed")
        }
    }
    
    /*
     *
     * Miscellaneous
     *
     */
    
    func getDateLimitString(timePeriod: Double) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // this line found at http://stackoverflow.com/questions/10209427/subtract-7-days-from-current-date
        let limitDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: Int(-timePeriod), toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        
        return dateFormatter.stringFromDate(limitDate!)
    }
}