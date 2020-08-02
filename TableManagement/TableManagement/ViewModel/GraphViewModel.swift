//
//  GraphViewModel.swift
//  TableManagement
//
//  Created by Admin on 02.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class GraphViewModel {
    var count: Int {
        return numbersData.count
    }
    
    private var numbersData: NumbersData
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func min() -> Float? {
        guard let min = numbersData.min() else {
            return nil
        }
        
        return min.value
    }
    
    func max() -> Float? {
        guard let max = numbersData.max() else {
            return nil
        }
        
        return max.value
    }
    
    func number(at index: Int) -> Float {
        return numbersData.get(at: index).value
    }
}
