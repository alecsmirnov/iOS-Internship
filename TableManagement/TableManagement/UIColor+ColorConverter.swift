//
//  UIColor+ColorConverter.swift
//  TableManagement
//
//  Created by Admin on 23.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ color: Color) {
        self.init(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
    
    func toColor() -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Color(red: Float(red), green: Float(green), blue: Float(blue), alpha: Float(alpha))
    }
}
