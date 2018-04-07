//
//  Settings.swift
//  Finance
//
//  Created by student on 12/7/16.
//  Copyright © 2016 cs.eku.edu. All rights reserved.
//

import Foundation

class Setting {
    var currency: Int
    var sortBy: Int
    var timePeriod: Int
    
    init() {
        self.currency = 0
        self.sortBy = 0
        self.timePeriod = 0
    }
    
    init(currency: Int, sortBy: Int, timePeriod: Int) {
        self.currency = currency
        self.sortBy = sortBy
        self.timePeriod = timePeriod
    }
}