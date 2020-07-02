//
//  DataSource.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DataSource {
    var data: [Int] = randomNumbers(size: TableSize)
    
    static func randomNumbers(size: Int) -> [Int] {
        var data: [Int] = []
        
        for _ in 0...size {
            data.append(Int.random(in: 0..<size))
        }
        
        return data
    }
}
