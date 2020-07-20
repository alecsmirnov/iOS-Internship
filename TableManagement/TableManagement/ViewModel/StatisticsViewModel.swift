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
        return numbersData.isEmpty ? "" : String(format: "%.2f", numbersData.min()!.value!)
    }
    
    func max() -> String {
        return numbersData.isEmpty ? "" : String(format: "%.2f", numbersData.max()!.value!)
    }
    
    func average() -> String {
        return numbersData.isEmpty ? "-" : String(format: "%.2f", numbersData.average()!)
    }
}
