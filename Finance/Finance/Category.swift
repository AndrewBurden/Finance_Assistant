//
//  Category.swift
//  Finance
//
//  Created by Paul on 12/01/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//  Code was copied from https://www.sitepoint.com/managing-data-in-ios-apps-with-sqlite/ and modified.
//

import Foundation

class Category {
    let categoryID: Int64?
    var categoryName: String
    var categoryType: Int
    var categoryIcon: Int
    
    init(id: Int64) {
        categoryID = id
        categoryName = ""
        categoryType = 0
        categoryIcon = 0
    }
    
    init(id: Int64, name: String, type: Int, icon: Int) {
        categoryID = id
        categoryName = name
        categoryType = type
        categoryIcon = icon
    }
}