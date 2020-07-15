//
//  NumbersDataViewModel.swift
//  TableManagement
//
//  Created by Admin on 14.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class TableViewModel {
    private weak var numbersData: NumbersData!
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func append(number: Int) {
        numbersData.data.append(number)
    }
    
    func remove(at index: Int) {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        numbersData.data.remove(at: index)
    }
    
    func replace(at index: Int, with number: Int) {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        numbersData.data[index] = number
    }

    func get(at index: Int) -> Int {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        return numbersData.data[index]
    }
    
    func count() -> Int {
        return numbersData.data.count
    }
}
