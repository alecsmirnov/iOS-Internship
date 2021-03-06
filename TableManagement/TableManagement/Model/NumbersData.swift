//
//  NumbersData.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Number {
    var value: Float
    var color: Color
}

class NumbersData {
    private var data: [Number] = []
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var count: Int {
        return data.count
    }
    
    init(size: Int, range: Float) {
        for _ in 0..<size {
            let value = Float.random(in: -range..<range)
            let color = Color(hue: Float.random(in: 0...1), saturation: Float.random(in: 0.75...1), brightness: Float.random(in: 0.5...1))

            data.append(Number(value: value, color: color))
        }
    }
    
    func append(number: Number) {
        data.append(number)
    }
    
    func get(at index: Int) -> Number {
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
    
    func replace(at index: Int, with number: Number) {
        guard data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        data[index] = number
    }
    
    func min() -> Number? {
        return data.min { $0.value < $1.value }
    }
    
    func max() -> Number? {
        return data.max { $0.value < $1.value }
    }
    
    func average() -> Float? {
        return data.isEmpty ? nil : data.reduce(0.0) { $0 + $1.value } / Float(data.count)
    }
    
    deinit {
        data.removeAll()
    }
}
