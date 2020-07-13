//
//  DataSource.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DataSource {
    private var data: [Int] = []
    
    init(size: Int) {
        for _ in 0..<size {
            data.append(Int.random(in: -size..<size))
        }
    }
    
    func isEmpty() -> Bool {
        return data.isEmpty
    }
    
    func append(number: Int) {
        data.append(number)
    }
    
    func remove(at index: Int) {
        guard data.indices.contains(index) else {
            assertionFailure("Elemtn index is out of range")
            return
        }
        
        data.remove(at: index)
    }
    
    func replace(at index: Int, with number: Int) {
        guard data.indices.contains(index) else {
            assertionFailure("Elemtn index is out of range")
            return
        }
        
        data[index] = number
    }
    
    func count() -> Int {
        return data.count
    }
    
    func get(at index: Int) -> Int {
        guard data.indices.contains(index) else {
            assertionFailure("Elemtn index is out of range")
            return 0 // ?
        }
        
        return data[index]
    }
    
    func arrayData() -> [Int] {
        return data
    }
}
