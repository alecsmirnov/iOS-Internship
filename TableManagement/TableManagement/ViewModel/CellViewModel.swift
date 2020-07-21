//
//  CellViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    var valueText: String!
    var numberText: String!
    var color: Color!
    
    init(number: Number) {
        valueText = String(format: "%.2f", number.value)
        numberText = CellViewModel.capitalizeFirstLetter(NumberConverter.toText((number.value * 100).rounded() / 100))
        color = number.color
    }
    
    private static func capitalizeFirstLetter(_ string: String) -> String {
        return string.prefix(1).capitalized + string.dropFirst()
    }
}
