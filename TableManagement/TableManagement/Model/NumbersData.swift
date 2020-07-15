//
//  NumbersData.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class NumbersData {
    var data: [Int] = []
    
    init(size: Int) {
        for _ in 0..<size {
            data.append(Int.random(in: -size..<size))
        }
    }
    
    deinit {
        data.removeAll()
    }
}
