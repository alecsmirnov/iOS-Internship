//
//  DataSource.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

let TableSize: Int = 1

class DataSource {
    static let shared = DataSource(size: TableSize)
    
    var data: [Int] = []
    
    private init(size: Int) {
        for _ in 0..<size {
            data.append(Int.random(in: -size..<size))
        }
    }
}
