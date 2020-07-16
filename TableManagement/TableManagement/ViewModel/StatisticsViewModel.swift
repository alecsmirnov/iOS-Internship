//
//  StatisticsViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class StatisticsViewModel {
    /*
    var count: String!
    var min: String!
    var max: String!
    var average: String!
    
    private var numbersData: NumbersData! {
        didSet {
            updateData()
        }
    }
    
    init(numbersData: NumbersData) {
        setNumbersData(numbersData)
    }
    
    private func setNumbersData(_ numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    private func updateData() {
        count = String(numbersData.count())
        if numbersData.isEmpty() {
            min = "-"
            max = "-"
            average = "-"
        }
        else {
            min = String(numbersData.min()!)
            max = String(numbersData.max()!)
            average = String(format: "%.3f", numbersData.average()!)
        }
    }
    */
    
    private var numbersData: NumbersData!
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func count() -> String {
        return String(numbersData.count())
    }
        
    func min() -> String {
        return numbersData.isEmpty() ? "-" : String(numbersData.min()!)
    }
    
    func max() -> String {
        return numbersData.isEmpty() ? "-" : String(numbersData.max()!)
    }
    
    func average() -> String {
        return numbersData.isEmpty() ? "-" : String(format: "%.3f", numbersData.average()!)
    }
}
