//
//  Color.swift
//  TableManagement
//
//  Created by Admin on 23.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Color {
    var red: Float
    var green: Float
    var blue: Float
    var alpha: Float
    
    init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
