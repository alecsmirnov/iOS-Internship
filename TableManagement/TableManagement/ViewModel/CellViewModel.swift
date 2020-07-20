//
//  CellViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    var value: Float!
    var text: String!
    var color: Color!
    
    init(number: Number) {
        value = number.value
        text = String(format: "%.2f", number.value)
        color = number.color
    }
}
