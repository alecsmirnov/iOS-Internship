//
//  StatisticsViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class StatisticsViewModel {
    private weak var numbersData: NumbersData!
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func count() -> String {
        return String(numbersData.data.count)
    }
        
    func min() -> String {
        return numbersData.data.isEmpty ? "-" : String(numbersData.data.min()!)
    }
    
    func max() -> String {
        return numbersData.data.isEmpty ? "-" : String(numbersData.data.max()!)
    }
    
    func average() -> String {
        var averageString = "-"
        
        if !numbersData.data.isEmpty {
            let average = Double(numbersData.data.reduce(0, +)) / Double(numbersData.data.count)
            averageString = String(format: "%.3f", average)
        }
        
        return averageString
    }
}
