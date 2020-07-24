//
//  StatisticsViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class StatisticsViewModel {
    var count: String {
        return String(numbersData.count)
    }
    
    private var numbersData: NumbersData!
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func min() -> String {
        var minValue = ""
        
        if !numbersData.isEmpty {
            if let min = numbersData.min() {
                minValue =  String(format: "%.2f", min.value)
            }
        }
        
        return minValue
    }
    
    func max() -> String {
        var maxValue = ""
        
        if !numbersData.isEmpty {
            if let max = numbersData.max() {
                maxValue =  String(format: "%.2f", max.value)
            }
        }
        
        return maxValue
    }
    
    func average() -> String {
        var averageValue = "-"
        
        if !numbersData.isEmpty {
            if let average = numbersData.average() {
                averageValue = String(format: "%.2f", average)
            }
        }
        
        return averageValue
    }
}
