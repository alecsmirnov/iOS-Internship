//
//  Color.swift
//  TableManagement
//
//  Created by Admin on 23.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Color {
    var redInt: Int! {
        guard let red = red else {
            return nil
        }
        
        return Int(red * 255.0)
    }
    
    var greenInt: Int! {
        guard let green = green else {
            return nil
        }
        
        return Int(green * 255.0)
    }
    
    var blueInt: Int! {
        guard let blue = blue else {
            return nil
        }
        
        return Int(blue * 255.0)
    }
    
    var red: Float!
    var green: Float!
    var blue: Float!
    var alpha: Float!
    
    init(red: Float, green: Float, blue: Float, alpha: Float = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.red = Float(red) / 255.0
        self.green = Float(green) / 255.0
        self.blue = Float(blue) / 255.0
        self.alpha = Float(alpha) / 255.0
    }
}
