//
//  NumbersData.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class NumbersData {
    private var data: [Int] = []
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var count: Int {
        return data.count
    }
    
    init(size: Int) {
        for _ in 0..<size {
            data.append(Int.random(in: -size..<size))
        }
    }
    
    func append(number: Int) {
        data.append(number)
    }
    
    func get(at index: Int) -> Int {
        guard data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        return data[index]
    }
    
    func remove(at index: Int) {
        guard data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        data.remove(at: index)
    }
    
    func replace(at index: Int, with number: Int) {
        guard data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        data[index] = number
    }
    
    func min() -> Int? {
        return data.min()
    }
    
    func max() -> Int? {
        return data.max()
    }
    
    func average() -> Double? {
        return data.isEmpty ? nil : Double(data.reduce(0, +)) / Double(data.count)
    }
    
    deinit {
        data.removeAll()
    }
}
