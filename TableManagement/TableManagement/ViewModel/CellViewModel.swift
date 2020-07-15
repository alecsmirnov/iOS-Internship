//
//  CellViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    var text: String!
    
    init(number: Int) {
        text = String(number)
    }
}
